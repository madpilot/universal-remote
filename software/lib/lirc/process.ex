defmodule LIRC.Process do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    [irsend: irsend, irw: irw] = Application.get_env(:universal_remote, LIRC.Process)
    port = Port.open({:spawn_executable, irw}, [:line, :binary])
    {:ok, state |> Map.merge(%{port: port, irsend: irsend})}
  end

  def handle_info({_, {:data, {:eol, line}}}, state) do
    GenServer.cast(LIRC.Producer, {:lirc, line})
    {:noreply, state}
  end


  def handle_call({:list_devices}, _from, state) do
    {output, exit_code} = System.cmd(state[:irsend], ["list", "", ""])

    case exit_code do
      0 -> (
        devices = output
          |> String.split("\n")
          |> Enum.map(fn(line) ->
            case Regex.run(~r/^irsend: (.+)$/, line) do
              [_, device] -> device |> String.to_atom
            end
          end)

        {:reply, {:ok, devices}, state}
      )
    end
  end

  def handle_call({:list_commands, device}, _from, state) do
    device_string = device
       |> Atom.to_string

    {output, exit_code} = System.cmd(state[:irsend], ["list", device_string, ""])

    case exit_code do
      0 -> (
        commands = output
          |> String.split("\n")
          |> Enum.map(fn(line) ->
            case Regex.run(~r/^irsend:\s+\S+\s+(.+)$/, line) do
              [_, key] -> key |> String.downcase |> String.to_atom
            end
          end)

        {:reply, {:ok, commands}, state}
      )
    end
  end

  def handle_call({:send_command, device, key}, _from, state) do
    device_string = device
      |> Atom.to_string

    key_string = key
      |> Atom.to_string
      |> String.upcase

    {_, exit_code} = System.cmd(state[:irsend], ["send_once", device_string, key_string])

    case exit_code do
      0 -> {:reply, {:ok}, state}
    end
  end

  def list_devices() do
    GenServer.call(LIRC.Process, {:list_devices})
  end

  def list_commands(device) do
    GenServer.call(LIRC.Process, {:list_commands, device})
  end

  def send_command(device, command) do
    GenServer.call(LIRC.Process, {:send_command, device, command})
  end
end
