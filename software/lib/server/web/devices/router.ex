defmodule Server.Web.Devices.Router do
  use Plug.Router

  plug Plug.Logger, log: :info
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  def send_json(conn, status, obj) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, obj |> Poison.encode!)
  end

  get "/" do
    conn
    |> send_json(200, Devices.list |> Map.keys)
  end

  get "/:device" do
    with {:ok, module} <- Devices.get(device |> String.to_atom),
         list          <- module.commands()
    do
      send_json(conn, 200, list)
    else
      {:unknown_device} -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

  put "/:device/send" do
    %{"command" => command} = conn.body_params

    with :ok <- Devices.send_once(device |> String.to_atom, command |> String.to_atom) |> elem(0)
    do
      send_json(conn, 200, %{ok: "ok"})
    else
      :unknown_device -> send_json(conn, 404, %{error: "Not Found"})
      :unknown_command -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

  put "/:device/start" do
    %{"command" => command} = conn.body_params

    with :ok <- Devices.send_start(device |> String.to_atom, command |> String.to_atom) |> elem(0)
    do
      send_json(conn, 200, %{ok: "ok"})
    else
      :unknown_device -> send_json(conn, 404, %{error: "Not Found"})
      :unknown_command -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

  put "/:device/stop" do
    %{"command" => command} = conn.body_params

    with :ok <- Devices.send_stop(device |> String.to_atom, command |> String.to_atom) |> elem(0)
    do
      send_json(conn, 200, %{ok: "ok"})
    else
      :unknown_device -> send_json(conn, 404, %{error: "Not Found"})
      :unknown_command -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end
end
