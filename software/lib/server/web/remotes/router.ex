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

  get "/" do
    conn
    |> send_json(200, Remotes.list |> Map.keys)
  end

  get "/:bus" do
    with {:ok, module} <- Remotes.get(bus |> String.to_atom),
         {:ok, list} <- module.devices
    do
      send_json(conn, 200, list)
    else
      {:unknown_bus} -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

  get "/:bus/:device" do
    with {:ok, module} <- Remotes.get(bus |> String.to_atom),
         {:ok, list} <- module.commands(device |> String.to_atom)
    do
      send_json(conn, 200, list)
    else
      {:unknown_bus} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_remote} -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

  put "/:bus/:device/send" do
    %{"key" => key} = conn.body_params

    with {:ok, module} <- Remotes.get(bus |> String.to_atom),
         {:ok} <- module.send_once(device |> String.to_atom, key |> String.to_atom)
    do
      send_json(conn, 200, %{ok: "ok"})
    else
      {:unknown_bus} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_remote} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_command} -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

  put "/:bus/:device/start" do
    %{"key" => key} = conn.body_params

    with {:ok, module} <- Remotes.get(bus |> String.to_atom),
         {:ok} <- module.send_start(device |> String.to_atom, key |> String.to_atom)
    do
      send_json(conn, 200, %{ok: "ok"})
    else
      {:unknown_bus} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_remote} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_command} -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end

  put "/:bus/:device/stop" do
    %{"key" => key} = conn.body_params

    with {:ok, module} <- Remotes.get(bus |> String.to_atom),
         {:ok} <- module.send_stop(device |> String.to_atom, key |> String.to_atom)
    do
      send_json(conn, 200, %{ok: "ok"})
    else
      {:unknown_bus} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_remote} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_command} -> send_json(conn, 404, %{error: "Not Found"})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end
end
