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
        {:ok, loaded} -> loaded
      end
    end)

    {:ok, loaded}
  end

  defp load_file(file) do
    try do
      load_result = case Code.load_file(file) do
        [{module, _}] -> [file: file, module: module, name: module |> Macro.underscore |> String.to_atom]
      end

      Devices.register(load_result |> Keyword.get(:name), load_result |> Keyword.get(:module))
      {:ok, load_result}
    rescue
      e in CompileError -> (
        Logger.error "Error compiling #{file}"
        Logger.error "Line #{e.line}: #{e.description}"
        {:error, "Error compiling #{file}: Line #{e.line}: #{e.description}"}
      )
    end
  end

  defp unload_file(attr) do
    name = attr |> Keyword.get(:name)
    module = attr |> Keyword.get(:module)

    Devices.deregister(name)

    :code.purge(module)
    :code.delete(module)
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

  def load(file) do
    GenServer.call(__MODULE__, {:load, file})
  end

  def unload(file) do
    GenServer.cast(__MODULE__, {:unload, file})
  end

  def loaded(file) do
    GenServer.call(__MODULE__, {:loaded, file})
  end

  def handle_call({:load, file}, _from, state) do
    state
    |> find_attr(file)
    |> Enum.map(&unload_file(&1))

    Logger.info "Loading #{file}..."

    case load_file(file) do
      {:ok, loaded} -> {:reply, {:ok, loaded}, [loaded | state]}
      {:error, error} -> {:reply, {:error, error}, state}
    end
  end

  def handle_cast({:unload, file}, state) do
    find_attr(state, file)
    |> Enum.map(&unload_file(&1))

    Logger.info "Unloading #{file}..."
    {:noreply, state |> Enum.reject(fn(attr) -> attr |> Keyword.get(:file) == file end)}
  end

  def handle_call({:loaded, file}, _from, state) do
    {:reply, file_loaded(state, file), state}
  end
end
