defmodule Server.Websocket.Handler do
  use Supervisor

  @behaviour :cowboy_websocket_handler
  @timeout 60000

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    state = %{}
    setup_consumer
    {:ok, req, state, @timeout}
  end

  def websocket_handle({:text, "ping"}, req, state) do
    {:reply, {:text, "pong"}, req, state}
  end

  def websocket_handle({:text, message}, req, state) do
    IO.puts(message)
    {:ok, req, state}
  end

  def websocket_info(message, req, state) do
    IO.puts "Received message: #{inspect message}"
    {:reply, {:text, message}, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp setup_consumer() do
    child = supervisor(Server.Websocket.Consumer, [self()])
    {:ok, pid} = Supervisor.start_link([child], strategy: :one_for_one)
  end
end
