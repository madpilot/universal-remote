defmodule LIRC.Producer do
  use GenStage
  require Logger

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:producer, {:queue.new, 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  defp build_packet(command, device) do
    packet = %{command: command  |> String.downcase |> String.to_atom,
      destination: device |> String.to_atom,
      source: nil,
      bus: :lirc}
    Logger.debug "LIRC - Received #{inspect packet}"
    packet
  end

  defp parse_line(data) do
    case Regex.run(~r/\S+\s+\S{2}\s+(.+)\s+(.+)$/, data) do
      [_, command, device] -> build_packet(command, device)
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

  def handle_cast({:lirc, line}, {queue, demand}) do
    case line |> parse_line do
       nil -> dispatch_events(queue, demand, [])
      code -> dispatch_events(:queue.in(code, queue), demand, [])
    end
  end
end
