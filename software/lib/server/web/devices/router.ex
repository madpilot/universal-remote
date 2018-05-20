defmodule Server.Web.Devices.Router do
  use Plug.Router

  plug Plug.Logger, log: :info
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  get "/" do
    API.Devices.serve(%{action: :get_devices})
    |> send_reply(conn)
  end

  get "/:device" do
    API.Devices.serve(%{action: :get_actions, device: device})
    |> send_reply(conn)
  end

  put "/:device/send" do
    %{"command" => command} = conn.body_params

    API.Devices.serve(%{action: :send_command, device: device, command: command})
    |> send_reply(conn)
  end

  put "/:device/start" do
    %{"command" => command} = conn.body_params

    API.Devices.serve(%{action: :start_command, device: device, command: command})
    |> send_reply(conn)
  end

  put "/:device/stop" do
    %{"command" => command} = conn.body_params

    API.Devices.serve(%{action: :stop_command, device: device, command: command})
    |> send_reply(conn)
  end

  get "/:device/status" do
    API.Devices.serve(%{action: :list_statuses, device: device})
    |> send_reply(conn)
  end

  get "/:device/status/:status" do
    API.Devices.serve(%{action: :get_status, device: device, status: status})
    |> send_reply(conn)
  end

  defp send_json(conn, status, obj) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, obj |> Poison.encode!)
  end

  defp send_reply(reply, conn) do
    case reply do
      {:reply, payload} -> send_json(conn, 200, payload)
      :unknown_device -> send_json(conn, 404, %{error: "Not Found"})
      :unknown_command -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_device} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_command} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_status} -> send_json(conn, 404, %{error: "Not Found"})
      {:timeout, message} -> send_json(conn, 408, %{error: message})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end
end
