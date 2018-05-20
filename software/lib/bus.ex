defmodule Bus do
  use GenStage
  require Logger

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:producer_consumer, :ok, subscribe_to: [CEC.Producer, LIRC.Producer, Event.Producer]}
  end

  def handle_events(events, _from, state) do
    # Just pass the events straight through, so we have a unified bus
    events |> Enum.each(fn(event) -> Logger.debug("Bus - #{inspect event}") end)
    {:noreply, events, state}
  end
end
