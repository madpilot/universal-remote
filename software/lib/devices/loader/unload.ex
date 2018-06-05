defmodule Devices.Loader.Unload do
  require Logger

  def device(module) do
    Devices.deregister(module.name)
    module
  end

  def devices(modules) do
    modules |> Enum.map(&Devices.Loader.Unload.device(&1))
  end

  def module(module) do
    unsupervise(module.module)
    Devices.Loader.Code.purge(module.module)
    Devices.Loader.Code.delete(module.module)

    module
  end

  def modules(modules) do
    modules |> Enum.map(&Devices.Loader.Unload.module(&1))
  end

  def file(module) do
    Devices.Loader.Unload.module(module)
  end

  def files(state, modules) do
    modules
    |> Enum.map(&Devices.Loader.Unload.file(&1))

    state
    |> Enum.reject(fn(module) -> modules |> Enum.member?(module) end)
  end

  def unsupervise(module) do
    supervisor = Process.whereis(Supervisors.Devices)
    supervisor
      |> Supervisor.which_children
      |> Enum.filter(fn(x) -> x |> elem(0) == module end)
      |> Enum.each(fn(child) ->
        with  id <- child |> elem(0),
              :ok <- supervisor |> Supervisor.terminate_child(id),
              :ok <- supervisor |> Supervisor.delete_child(id)
        do
          Logger.info "#{module} has been terminated and is no longer under supervision"
        else
          {:error, message} -> Logger.info "#{module} not stopped: #{message}"
        end
      end)
  end
end
