defmodule LIRC.Consumer do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :the_state_does_not_matter, subscribe_to: [LIRC.Producer]}
  end

  def handle_events(events, _from, state) do
    events
    |> Enum.each(fn(ev) -> ev |> Apex.ap end)
    {:noreply, [], state}
  end
end
