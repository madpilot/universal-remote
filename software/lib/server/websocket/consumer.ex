defmodule Server.Websocket.Consumer do
  use GenStage

  def start_link(server) do
    GenStage.start_link(__MODULE__, %{server: server})
  end

  def init(state) do
    {:consumer, state, subscribe_to: [Event.Producer]}
  end

  def handle_events(events, _from, state) do
    events |> Enum.each(fn(event) -> send(state[:server], event |> Poison.encode!) end)
    {:noreply, [], state}
  end
end
