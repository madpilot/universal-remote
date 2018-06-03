defmodule Devices.Filewatcher do
  use GenServer
  require Logger

  def start_link(files) do
    GenServer.start_link(__MODULE__, files)
  end

  def init(files) do
    {:ok, pid} = FileSystem.start_link(dirs: files)
    FileSystem.subscribe(pid)
    {:ok, %{pid: pid}}
  end

  def remove_code(file) do
    Devices.Loader.unload_file(file)
  end

  def update_code(file) do
    Devices.Loader.load_file(file)
  end

  def handle_file_event(events, path) do
    case events |> Enum.member?(:removed) do
      true -> remove_code(path)
      false -> update_code(path)
    end
  end

  def handle_info({:file_event, pid, {path, events}}, %{pid: pid} = state) do
    case Regex.match?(~r/\.exs$/, path) do
      true -> handle_file_event(events, path)
      false -> nil
    end

    {:noreply, state}
  end

  def handle_info({:file_event, pid, :stop}, %{pid: pid} = state) do
    {:noreply, state}
  end
end
