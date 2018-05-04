defmodule CEC.Producer do
  use GenStage
  require Logger

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:producer, {:queue.new, 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  defp map_code(code) do
    Logger.debug "CEC - Received #{code}"
    CEC.Parsers.Parser.from_code(code)
  end

  defp parse_line(data) do
    case Regex.run(~r/\s*TRAFFIC:\s+\[.+\]\s+(<<|>>)\s(.+)$/, data) do
      [_, _, code] -> code |> map_code
                 _ -> nil
    end
  end

  defp dispatch_events(queue, demand, events) do
    with l when l > 0 <- :queue.len(queue),
         d when d > 0 <- demand,
         {{:value, event}, queue} = :queue.out(queue)
    do
      dispatch_events(queue, demand - 1, [event | events])
    else
      _ -> {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end

  def handle_demand(incoming_demand, {queue, demand}) do
    dispatch_events(queue, incoming_demand + demand, [])
  end

  def handle_cast({:cec, line}, {queue, demand}) do
    case line |> parse_line do
       nil -> dispatch_events(queue, demand, [])
      code -> dispatch_events(:queue.in(code, queue), demand, [])
    end
  end
end
