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
    Devices.Loader.unload(file)
  end

  def load_code(file) do
    Devices.Loader.load(file)
  end

  def reload_code(file) do
    Devices.Loader.reload(file)
  end

  defp normalize_events_result(_has_created, _has_modified, _has_renamed, has_removed) when has_removed == true do
    :removed
  end

  defp normalize_events_result(has_created, _has_modified, has_renamed, _has_removed) when has_created == true and not has_renamed == true do
    :created
  end

  defp normalize_events_result(has_created, has_modified, has_renamed, _has_removed) when has_renamed == true or (not has_created and has_modified) do
    :updated
  end

  defp normalize_events(events) do
    has_removed = events |> Enum.filter(fn(event) -> event == :removed end) |> length != 0
    has_created = events |> Enum.filter(fn(event) -> event == :created end) |> length != 0
    has_modified = events |> Enum.filter(fn(event) -> event == :modified end) |> length != 0
    has_renamed = events |> Enum.filter(fn(event) -> event == :renamed end) |> length != 0
    normalize_events_result(has_created, has_modified, has_renamed, has_removed)
  end

  def handle_file_event(events, path) do
    case normalize_events(events) do
      :created -> load_code(path)
      :updated -> reload_code(path)
      :removed -> remove_code(path)
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
