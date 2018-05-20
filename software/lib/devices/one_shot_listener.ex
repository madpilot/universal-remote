defmodule Devices.OneShotListener do
  use GenStage

  def wait_for(filter, caller) do
    Devices.Listener.listen_for(filter, caller, __MODULE__)
  end

  def init(state) do
    Devices.Listener.init(state)
  end

  def handle_events(events, _from, state) do
    filter = state[:filter]

    case events |> Devices.Listener.completed(filter) do
      %{match: true, result: event} -> (
        send(state[:caller], {:matched, event})

        # Filter has matched. Our work here is done
        {:stop, :normal, state}
      )
      _ -> {:noreply, [], state}
    end
  end
end
