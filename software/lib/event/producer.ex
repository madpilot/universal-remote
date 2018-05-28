defmodule Event.Producer do
  use GenStage
  require Logger

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, {:queue.new, 0}, dispatcher: GenStage.BroadcastDispatcher}
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

  def handle_cast({:broadcast, payload}, {queue, demand}) do
    Logger.debug "Event - #{inspect payload}"
    dispatch_events(:queue.in(payload, queue), demand, [])
  end

  def broadcast(payload) do
    GenServer.cast(__MODULE__, {:broadcast, payload})
  end
end
