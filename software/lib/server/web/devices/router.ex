defmodule Server.Web.Devices.Router do
  use Plug.Router

  plug Plug.Logger, log: :info

  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  get "/" do
    serve(%{action: :get_devices})
    |> send_reply(conn)
  end

  get "/:device" do
    serve(%{action: :get_metadata, device: device})
    |> send_reply(conn)
  end

  put "/:device/send" do
    %{"command" => command} = conn.body_params

    serve(%{action: :send_command, device: device, command: command})
    |> send_reply(conn)
  end

  put "/:device/start" do
    %{"command" => command} = conn.body_params

    serve(%{action: :start_command, device: device, command: command})
    |> send_reply(conn)
  end

  put "/:device/stop" do
    %{"command" => command} = conn.body_params

    serve(%{action: :stop_command, device: device, command: command})
    |> send_reply(conn)
  end

  get "/:device/status" do
    serve(%{action: :list_statuses, device: device})
    |> send_reply(conn)
  end

  get "/:device/status/:status" do
    serve(%{action: :get_status, device: device, status: status})
    |> send_reply(conn)
  end

  post _ do
    send_reply({:not_acceptable, "POST not supported. Use the PUT verb"}, conn)
  end

  delete _ do
    send_reply({:not_acceptable, "DELETE is not supported"}, conn)
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, %{error: "Not Found"} |> Poison.encode!)
  end

  defp serve(payload) do
    try do
      API.Devices.serve(payload |> Map.new(fn {k, v} -> {atomize(k), atomize(v)} end))
    rescue
      _ in ArgumentError -> {:error, "Invalid input"}
    end
  end

  defp atomize(obj) when is_atom(obj) do
    obj
  end

  defp atomize(obj) when is_binary(obj) do
    String.to_existing_atom(obj)
  end

  defp send_reply(reply, conn) do
    case reply do
      {:ok} -> conn |> send_resp(:ok, "")
      {:reply, payload} -> send_json(conn, 200, payload)
      :unknown_device -> send_json(conn, 404, %{error: "Not Found"})
      :unknown_command -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_device} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_command} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_status} -> send_json(conn, 404, %{error: "Not Found"})
      {:not_acceptable, message} -> send_json(conn, 406, %{error: message})
      {:timeout, message} -> send_json(conn, 408, %{error: message})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

    defp send_json(conn, status, obj) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, obj |> Poison.encode!)
  end
end
