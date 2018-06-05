defmodule Devices.Loader.Load do
  require Logger
  alias Devices.Loader.Module

  defp compile(file) do
    try do
      case Devices.Loader.Code.load_file(file) do
        [{module, _}] -> {:ok, %Module{file: file, module: module, name: module |> Macro.underscore |> String.to_atom}}
        [] -> {:error, "Empty file"}
      end
    rescue
      e in CompileError -> (
        {:error, e}
      )
      e in TokenMissingError -> (
        {:error, e}
      )
    end
  end

  def device(module) do
    Devices.register(module.name, module.module)
  end

  def devices(modules) do
    modules |> Enum.each(fn(module) -> device(module) end)
  end

  def file(state, file) do
    with result <- compile(file),
        {:ok, new_module} <- result
    do
      {:ok, [new_module | state]}
    else
      message -> message
    end
  end

  def supervise(modules) do
    modules
    |> Enum.map(fn(module) ->
      try do
        spec = %{
          id: module.module,
          start: {module.module, :start_link, []},
          restart: :transient,
          type: :worker
        }

        result = case Process.whereis(Supervisors.Devices) do
          nil -> nil
          pid -> pid |> Supervisor.start_child(spec)
        end

        case result do
          {:ok, _} -> Logger.info "#{spec[:id]} has been started and is under supervision"
          {:error, reasons} -> Logger.info "#{spec[:id]} not started: #{reasons |> elem(0)}"
        end
      rescue
        _ in Protocol.UndefinedError -> Logger.error "Unable to supervise #{module.module}. Did you add 'use Device'?"
      end
    end)
  end
end
