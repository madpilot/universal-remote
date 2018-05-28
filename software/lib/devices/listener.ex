defmodule Devices.Listener do
  use GenStage

  def listen_for(filter, caller, module \\ __MODULE__) do
    state = %{filter: filter, caller: caller}
    GenStage.start_link(module, state)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [CEC.Producer, LIRC.Producer, Event.Producer]}
  end

  def completed(events, filter) do
    events
      |> Enum.map(fn(event) ->
        reject_keys = event
          |> Map.keys
          |> Enum.reject(fn(x) ->
            filter |> Map.keys |> Enum.member?(x)
          end)

        case event |> Map.drop(reject_keys) do
          ^filter -> %{match: true, result: event}
          _ -> %{match: false}
        end
      end)
      |> Enum.filter(fn(event) -> event[:match] end)
      |> List.first
  end

  def handle_events(events, _from, state) do
    filter = state[:filter]

    case events |> completed(filter) do
      %{match: true, result: event} -> send(state[:caller], {:matched, event})
      _ -> nil
    end
    {:noreply, [], state}
  end
end
