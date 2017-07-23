defmodule CEC.Process do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: :cec])
  end

  def init(state) do
    port = Port.open({:spawn_executable, "/Users/myles/Projects/ir-blaster/software/spec/fake/cec-client"}, [:stream, :binary, :exit_status, :hide, :use_stdio, :stderr_to_stdout])
    {:ok, state |> Map.merge(%{port: port})}
  end

  def send_code(code) do
    GenServer.call(:cec, {:send_code, code})
  end

  defp parse_line(data) do
    case Regex.run(~r/\s*TRAFFIC:\s+\[.+\]\s+(<<|>>)\s(.+)$/, data) do
      [_, _, code] -> code
                      |> IO.puts
      _ -> nil
    end
  end

  def handle_call({:send_code, code}, _from, state) do
    state[:port] |> send({self(), {:command, "tx #{code}\n"}})
    {:reply, {:ok}, state}
  end

  def handle_info(msg, state) do
    case msg do
      {_, {:data, data}} -> data |> parse_line
    end
    {:noreply, state}
  end
end
