defmodule CEC.Producer do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init(events) do
    {:producer, %{events: events}}
  end

  defp parse_line(data) do
    case Regex.run(~r/\s*TRAFFIC:\s+\[.+\]\s+(<<|>>)\s(.+)$/, data) do
      [_, _, code] -> code
                 _ -> nil
    end
  end

  def handle_demand(demand, %{events: events}) when demand > 0 do
    {:noreply, events, demand + 1}
  end

  def handle_cast({:cec, line}, state) do
    data = line
           |> parse_line

    case data do
      nil -> {:noreply, [], state}
      code -> {:noreply, [code], state}
    end
  end
end
