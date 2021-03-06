defmodule LIRC.Process do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    [irsend: irsend, irw: irw] = Application.get_env(:universal_remote, LIRC.Process)
    Logger.info "Starting irw"
    Logger.debug "irw: #{irw}"
    Logger.debug "irsend: #{irsend}"
    port = Port.open({:spawn_executable, irw}, [:line, :binary])
    {:ok, state |> Map.merge(%{port: port, irsend: irsend})}
  end

  defp exec_error(body, state) do
    case Regex.run(~r/unknown (command|remote)/, body) do
      [_, "remote"] -> {:reply, {:unknown_remote}, state}
      [_, "command"] -> {:reply, {:unknown_command}, state}
      _ -> {:reply, {:error}, state}
    end
  end

  defp exec_command(device, key, send_state, _from, state) do
    device_string = device
      |> Atom.to_string

    key_string = key
      |> Atom.to_string
      |> String.upcase

    {body, exit_code} = System.cmd(state[:irsend], [send_state, device_string, key_string], [stderr_to_stdout: true])

    case exit_code do
      0 -> (
        LIRC.Producer.notify(device, key, send_state)
        {:reply, {:ok}, state}
      )
      1 -> exec_error(body, state)
    end
  end

  def handle_info({_, {:data, {:eol, line}}}, state) do
    GenStage.cast(LIRC.Producer, {:lirc, line})
    {:noreply, state}
  end

  def handle_call({:list_devices}, _from, state) do
    Logger.debug "LIRC - Listing devices"
    {output, exit_code} = System.cmd(state[:irsend], ["list", "", ""], [stderr_to_stdout: true])

    case exit_code do
      0 -> (
        devices = output
          |> String.split("\n", trim: true)
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
    Logger.debug "LIRC - Listing commands for #{device}"
    device_string = device
       |> Atom.to_string

    {output, exit_code} = System.cmd(state[:irsend], ["list", device_string, ""], [stderr_to_stdout: true])

    case exit_code do
      0 -> (
        commands = output
          |> String.split("\n", trim: true)
          |> Enum.map(fn(line) ->
            case Regex.run(~r/^irsend:\s+\S+\s+(.+)$/, line) do
              [_, key] -> key |> String.downcase |> String.to_atom
            end
          end)

        {:reply, {:ok, commands}, state}
      )
      1 -> {:reply, {:unknown_remote}, state}
    end
  end

  def handle_call({:send_once, device, key}, from, state) do
    Logger.debug "LIRC - Sending #{key} to #{device}"
    exec_command(device, key, "send_once", from, state)
  end

  def handle_call({:send_start, device, key}, from, state) do
    Logger.debug "LIRC - Sending start #{key} to #{device}"
    exec_command(device, key, "send_start", from, state)
  end

  def handle_call({:send_stop, device, key}, from, state) do
    Logger.debug "LIRC - Sending stop #{key} to #{device}"
    exec_command(device, key, "send_stop", from, state)
  end

  def list_devices() do
    GenServer.call(LIRC.Process, {:list_devices})
  end

  def list_commands(device) do
    GenServer.call(LIRC.Process, {:list_commands, device})
  end

  def send_once(device, command) do
    GenServer.call(LIRC.Process, {:send_once, device, command})
  end

  def send_start(device, command) do
    GenServer.call(LIRC.Process, {:send_start, device, command})
  end

  def send_stop(device, command) do
    GenServer.call(LIRC.Process, {:send_stop, device, command})
  end

  def terminate(_reason, state) do
    Logger.debug "Killing irw"
    # Do this better...
    # We should setup a link. See: https://hexdocs.pm/elixir/GenServer.html#c:terminate/2
    {:os_pid, pid} = Port.info(state[:port], :os_pid)
    Port.close(state[:port])
    System.cmd("kill", [pid])
  end
end
