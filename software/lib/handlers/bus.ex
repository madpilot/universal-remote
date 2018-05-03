defmodule Bus do
  use GenStage

  def wait_for(filter, timeout \\ 1000, do: block) do
    state = %{filter: filter, match: false, result: nil, timeout: timeout }
    {:ok, pid} = GenStage.start_link(__MODULE__, state)

    _ = block

    Bus.decrement_timer(pid)
    result = Bus.result(pid)
    Process.exit(pid, :normal)
    result
  end

  def init(state) do
    {:consumer, state, subscribe_to: [CEC.Producer, LIRC.Producer]}
  end

  def decrement_timer(pid) do
    Task.async(fn() ->
      Process.sleep(1)
      GenStage.cast(pid, {:decrement_timer})
      Bus.decrement_timer(pid)
     end)
  end

  def handle_events(events, _from, state) do
    filter = state[:filter]

    completed = events
      |> Enum.map(fn(event) ->
        reject_keys |> Enum.reduce(event, fn(e, x) -> e |> Map.delete(x) end)

        case event |> Map.drop(reject_keys) do
          ^filter -> %{match: true, result: event}
          _ -> %{match: false}
        end
      end)
      |> Enum.filter(fn(event) -> event[:match] end)
      |> List.first

    case completed do
      nil -> {:noreply, [], state}
      completed -> state |> Map.merge(completed)
    end
  end

  def handle_cast({:decrement_timer}, state) do
    {:noreply, [], state |> Map.put(:timeout, Kernel.max(state[:timeout] - 1, 0))}
  end

  def handle_call({:complete}, _from, state) do
    case state do
      %{timeout: 0} -> {:reply, {:timeout}, [], state}
      %{match: true, result: result} -> {:reply, {:complete, result}, [], state}
      _ -> {:reply, {:waiting}, [], state}
    end
  end

  def result(pid) do
    case GenStage.call(pid, {:complete}) do
      {:timeout} -> raise "Timeout"
      {:complete, res} -> res
      _ -> result(pid)
    end
  end
end
