defmodule CEC.Producer do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, [])
  end

  def init(events) do
    {:producer, %{events: events}}
  end

  defp parse_line(data) do
    case Regex.run(~r/\s*TRAFFIC:\s+\[.+\]\s+(<<|>>)\s(.+)$/, data) do
      [_, _, code] -> code
                 _ -> ""
    end
  end

  def handle_demand(demand, %{events: events}) when demand > 0 do
    events |> IO.inspect
    {:noreply, ["Hi"], demand + 1}
  end

  def handle_info({_, {:data, {:eol, msg}} }, state) do
    case msg |> parse_line do
        "" -> nil
      code -> IO.puts code
    end

    {:noreply, [], state}
  end
end
