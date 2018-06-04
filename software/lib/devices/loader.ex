defmodule Devices.Loader.Code do
  def load_file(file) do
    Code.load_file(file)
  end

  def purge(module) do
    :code.purge(module)
  end

  def delete(module) do
    :code.delete(module)
  end
end

defmodule Devices.Loader do
  use GenServer
  require Logger

  def start_link(files) do
    GenServer.start_link(__MODULE__, files, [name: __MODULE__])
  end

  def init(files) do
    loaded = files
    |> Enum.map(fn(path) ->
      Path.wildcard("#{path}/*.exs")
      |> Enum.map(fn(file) ->
        file
      end)
    end)
    |> List.flatten
    |> Enum.map(fn(file) ->
      case load_file(file) do
        {:ok, loaded} -> (
          Devices.register(loaded |> Keyword.get(:name), loaded |> Keyword.get(:module))
          loaded
        )
      end
    end)

    {:ok, loaded}
  end

  defp load_file(file) do
    try do
      load_result = case Devices.Loader.Code.load_file(file) do
        [{module, _}] -> [file: file, module: module, name: module |> Macro.underscore |> String.to_atom]
      end

      {:ok, load_result}
    rescue
      e in CompileError -> (
        Logger.error "Error compiling #{file}"
        Logger.error "Line #{e.line}: #{e.description}"
        {:error, e}
      )
    end
  end

  defp unload_file(attr) do
    name = attr |> Keyword.get(:name)
    module = attr |> Keyword.get(:module)

    Devices.Loader.Code.purge(module)
    Devices.Loader.Code.delete(module)
  end

  defp find_attr(state, file) do
    state
    |> Enum.filter(fn(attr) -> attr |> Keyword.get(:file) == file end)
  end

  defp file_loaded(state, file) do
    matched = state
    |> find_attr(file)

    length(matched) != 0
  end

  def handle_load(file, state) do
    case load_file(file) do
      {:ok, loaded} -> (
        Devices.register(loaded |> Keyword.get(:name), loaded |> Keyword.get(:module))
        {:reply, {:ok, loaded}, [loaded | state]}
      )
      {:error, error} -> {:reply, {:error, error}, state}
    end
  end

  def handle_reload(file, state) do
    case load_file(file) do
      {:ok, loaded} -> {:reply, {:ok, loaded}, state}
      {:error, error} -> {:reply, {:error, error}, state}
    end
  end

  def handle_unload(file, state) do
    find_attr(state, file)
    |> Enum.map(fn(attr) ->
      unload_file(attr)
      Devices.deregister(attr |> Keyword.get(:name))
    end)

    {:reply, :ok, state |> Enum.reject(fn(attr) -> attr |> Keyword.get(:file) == file end)}
  end

  def handle_call({:load, file}, _from, state) do
    # state
    # |> find_attr(file)
    # |> Enum.map(&unload_file(&1))

    Logger.info "Loading #{file}..."
    handle_load(file, state)
  end

  def handle_call({:reload, file}, _from, state) do
    Logger.info "Reloading #{file}..."
    case loaded(file) do
      true -> handle_reload(file, state)
      false -> handle_load(file, state)
    end
  end

  def handle_call({:unload, file}, _from, state) do
    Logger.info "Unloading #{file}..."
    handle_unload(file, state)
  end

  def handle_call({:loaded, file}, _from, state) do
    {:reply, file_loaded(state, file), state}
  end

  def load(file) do
    GenServer.call(__MODULE__, {:load, file})
  end

  def reload(file) do
    GenServer.call(__MODULE__, {:reload, file})
  end

  def unload(file) do
    GenServer.call(__MODULE__, {:unload, file})
  end

  def loaded(file) do
    GenServer.call(__MODULE__, {:loaded, file})
  end
end
