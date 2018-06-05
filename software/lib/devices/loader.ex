defmodule Devices.Loader do
  use GenServer
  require Logger

  def start_link(files) do
    GenServer.start_link(__MODULE__, files, [name: __MODULE__])
  end

  def init(files) do
    Process.send_after(self(), {:load_files, files}, 500)
    {:ok, []}
  end

  def handle_info({:load_files, files}, state) do
    loaded = files
      |> Enum.map(fn(path) -> Path.wildcard("#{path}/*.exs") end)
      |> List.flatten
      |> Enum.reduce([], fn(x, acc) ->
        case acc |> Devices.Loader.Load.file(x) do
          {:ok, modules} -> (
            Devices.Loader.Load.devices(modules)
            Devices.Loader.Load.supervise(modules)
            modules
          )
        end
      end)

    {:noreply, state ++ loaded}
  end

  defp find_modules(state, file) do
    state
    |> Enum.filter(fn(loaded) -> loaded.file == file end)
  end

  defp module_loaded(state, file) do
    matched = state
    |> find_modules(file)

    length(matched) != 0
  end

  def handle_call({:load, file}, _from, state) do
    Logger.info "Loading #{file}..."
    with loaded      <- Devices.Loader.Load.file(state, file),
         {:ok, state} <- loaded,
         modules = find_modules(state, file)
    do
      Devices.Loader.Load.devices(modules)
      Devices.Loader.Load.supervise(modules)

      {:reply, modules, state}
    else
      {:error, e} -> {:error, e}
    end
  end

  def handle_call({:unload, file}, _from, state) do
    Logger.info "Unloading #{file}..."

    loaded = find_modules(state, file)
    Devices.Loader.Unload.devices(loaded)
    state = Devices.Loader.Unload.files(state, loaded)

    {:reply, :ok, state}
  end

  def handle_call({:loaded, file}, _from, state) do
    {:reply, module_loaded(state, file), state}
  end

  def load(file) do
    GenServer.call(__MODULE__, {:load, file})
  end

  def reload(file) do
    GenServer.call(__MODULE__, {:load, file})
  end

  def unload(file) do
    GenServer.call(__MODULE__, {:unload, file})
  end

  def loaded(file) do
    GenServer.call(__MODULE__, {:loaded, file})
  end
end
