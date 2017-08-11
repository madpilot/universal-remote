defmodule Server.Web.Remotes.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  def return_json(conn, json) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json  |> Poison.encode!)
  end

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, [:cec, :lirc] |> Poison.encode!)
  end

  get "/:bus" do
    devices = case bus do
      "cec" -> CEC.Remote.devices
      "lirc" -> LIRC.Remote.devices
      _ -> :not_found
    end

    case devices do
      :not_found -> send_resp(conn, 404, "Not found")
      {:ok, list} -> return_json(conn, list)
    end
  end

  get "/:bus/:device" do
    commands = case bus do
      "cec" -> CEC.Remote.commands(device |> String.to_atom)
      "lirc" -> LIRC.Remote.commands(device |> String.to_atom)
      _ -> :not_found
    end

    case commands do
      :not_found -> send_resp(conn, 404, "Not found")
      {:ok, list} -> return_json(conn, list)
    end
  end

  put "/:bus/:device/send" do
    %{key: key} = conn.body_params

    commands = case bus do
      "cec" -> CEC.Remote.send_once(device |> String.to_atom, key |> String.to_atom)
      "lirc" -> LIRC.Remote.send_once(device |> String.to_atom, key |> String.to_atom)
      _ -> :not_found
    end

    case commands do
      :not_found -> send_resp(conn, 404, "Not found")
      :ok -> send_resp(conn, 200, "Ok")
    end
  end

  put "/:bus/:device/start" do
    %{key: key} = conn.body_params

    commands = case bus do
      "cec" -> CEC.Remote.start_send(device |> String.to_atom, key |> String.to_atom)
      "lirc" -> LIRC.Remote.start_send(device |> String.to_atom, key |> String.to_atom)
      _ -> :not_found
    end

    case commands do
      :not_found -> send_resp(conn, 404, "Not found")
      :ok -> send_resp(conn, 200, "Ok")
    end
  end

  put "/:bus/:device/stop" do
    %{key: key} = conn.body_params

    commands = case bus do
      "cec" -> CEC.Remote.stop_send(device |> String.to_atom, key |> String.to_atom)
      "lirc" -> LIRC.Remote.stop_send(device |> String.to_atom, key |> String.to_atom)
      _ -> :not_found
    end

    case commands do
      :not_found -> send_resp(conn, 404, "Not found")
      :ok -> send_resp(conn, 200, "Ok")
    end
  end
end
