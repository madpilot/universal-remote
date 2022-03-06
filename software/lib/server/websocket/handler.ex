defmodule Server.Websocket.Handler do
  use Supervisor

  @behaviour :cowboy_websocket_handler
  @timeout 60000

  def init(_) do
    {:ok}
  end

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    state = %{}
    setup_consumer()
    {:ok, req, state, @timeout}
  end

  def websocket_handle({:text, "ping"}, req, state) do
    {:reply, {:text, "pong"}, req, state}
  end

  def websocket_handle({:ping, _}, req, state) do
    {:ok, req, state}
  end

  def websocket_handle({:text, message}, req, state) do
    try do
      with {:ok, payload} <- message |> Poison.decode,
           payload <- payload
                      |> Map.new(fn {k, v} ->
                        {String.to_existing_atom(k), String.to_existing_atom(v)}
                      end),
           channel <- payload[:channel],
           payload <- payload |> Map.delete(:channel)
      do
        dispatch(channel, payload, req, state)
      else
        _ -> encode_payload(:reply, %{error: "Message must be JSON"}, req, state)
      end
    rescue
      _ in ArgumentError -> encode_payload(:reply, %{error: "Invalid input"}, req, state)
    end
  end

  def websocket_info(message, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp setup_consumer() do
    child = supervisor(Server.Websocket.Consumer, [self()])
    Supervisor.start_link([child], strategy: :one_for_one)
  end

  defp dispatch(channel, payload, req, state) when channel == :remotes do
    case API.Remotes.serve(payload) do
      {:ok} -> {:ok, req, state}
      {:reply, payload} -> encode_payload(:reply, payload, req, state)
      :unknown_device -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      :unknown_command -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      {:unknown_device} -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      {:unknown_command} -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      {:unknown_status} -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      message -> encode_payload(:reply, message, req, state)
    end
  end

  defp dispatch(channel, payload, req, state) when channel == :devices do
    case API.Devices.serve(payload) do
      {:ok} -> {:ok, req, state}
      {:reply, payload} -> encode_payload(:reply, payload, req, state)
      :unknown_bus -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      :unknown_remote -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      :unknown_command -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      {:unknown_bus} -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      {:unknown_remote} -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      {:unknown_command} -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      {:unknown_status} -> encode_payload(:reply, %{error: "Not Found"}, req, state)
      message -> encode_payload(:reply, message, req, state)
    end
  end

  defp dispatch(channel, _, req, state) do
    encode_payload(:reply, %{error: "Unknown channel: #{channel}"}, req, state)
  end

  defp encode_payload(status, payload, req, state) do
    {status, {:text, payload |> Poison.encode!}, req, state}
  end
end
