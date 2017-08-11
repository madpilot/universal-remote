defmodule Server.Web.Remotes.Router do
  use Plug.Router

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

  def bus_module(bus) do
    case bus do
      "cec" -> {:ok, CEC.Remote}
      "lirc" -> {:ok, LIRC.Remote}
      _ -> {:error, :not_found}
    end
  end

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_json(200, [:cec, :lirc])
  end

  get "/:bus" do
    with {:ok, module} <- bus_module(bus),
         {:ok, list} <- module.devices
    do
      send_json(conn, 200, list)
    else
      {:error, :not_found} -> send_resp(conn, 404, "Not found")
      _ ->  send_resp(conn, 500, "Error")
    end
  end

  get "/:bus/:device" do
    with {:ok, module} <- bus_module(bus),
         {:ok, list} <- module.commands(device |> String.to_atom)
    do
      send_json(conn, 200, list)
    else
      {:error, :not_found} -> send_resp(conn, 404, "Not found")
      _ ->  send_resp(conn, 500, "Error")
    end
  end

  put "/:bus/:device/send" do
    %{key: key} = conn.body_params

    with {:ok, module} <- bus_module(bus),
         {:ok} <- module.send_once(device |> String.to_atom, key |> String.to_atom)
    do
      send_resp(conn, 200, "OK")
    else
      {:error, :not_found} -> send_resp(conn, 404, "Not found")
      _ ->  send_resp(conn, 500, "Error")
    end
  end

  put "/:bus/:device/start" do
    %{key: key} = conn.body_params

    with {:ok, module} <- bus_module(bus),
         {:ok} <- module.start_send(device |> String.to_atom, key |> String.to_atom)
    do
      send_resp(conn, 200, "OK")
    else
      {:error, :not_found} -> send_resp(conn, 404, "Not found")
      _ ->  send_resp(conn, 500, "Error")
    end
  end

  put "/:bus/:device/stop" do
    %{key: key} = conn.body_params

    with {:ok, module} <- bus_module(bus),
         {:ok} <- module.stop_send(device |> String.to_atom, key |> String.to_atom)
    do
      send_resp(conn, 200, "OK")
    else
      {:error, :not_found} -> send_resp(conn, 404, "Not found")
      _ ->  send_resp(conn, 500, "Error")
    end
  end
end
