 defmodule Handlers do
  use Supervisor
  require Logger

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, [name: __MODULE__])
  end

  def init(files) do
    children = files
    |> Enum.map(fn(file) ->
      case Code.load_file(file) do
        [{module, _}] -> module
      end
    end)
    |> Enum.map(fn(module) -> supervisor(module, []) end)

    supervise(children, strategy: :one_for_one)
  end
end
