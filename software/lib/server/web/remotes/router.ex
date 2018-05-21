defmodule Server.Web.Remotes.Router do
  use Plug.Router

  plug Plug.Logger, log: :info
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  get "/" do
    _ = :action
    serve(%{action: :get_buses})
    |> send_reply(conn)
  end

  get "/:bus" do
    serve(%{action: :get_remotes, bus: bus})
    |> send_reply(conn)
  end

  get "/:bus/:remote" do
    serve(%{action: :get_keys, bus: bus, remote: remote})
    |> send_reply(conn)
  end

  put "/:bus/:remote/send" do
    %{"key" => key} = conn.body_params

    serve(%{action: :send_key, bus: bus, remote: remote, key: key})
    |> send_reply(conn)
  end

  put "/:bus/:remote/start" do
    %{"key" => key} = conn.body_params

    serve(%{action: :start_key, bus: bus, remote: remote, key: key})
    |> send_reply(conn)
  end

  put "/:bus/:remote/stop" do
    %{"key" => key} = conn.body_params

    serve(%{action: :stop_key, bus: bus, remote: remote, key: key})
    |> send_reply(conn)
  end

  defp serve(payload) do
    try do
      API.Remotes.serve(payload |> Map.new(fn {k, v} -> {atomize(k), atomize(v)} end))
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

  defp send_json(conn, status, obj) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, obj |> Poison.encode!)
  end

  defp send_reply(reply, conn) do
    case reply do
      {:ok} -> conn |> send_resp(:ok, "")
      {:reply, payload} -> send_json(conn, 200, payload)
      :unknown_bus -> send_json(conn, 404, %{error: "Not Found"})
      :unknown_remote -> send_json(conn, 404, %{error: "Not Found"})
      :unknown_command -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_bus} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_remote} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_command} -> send_json(conn, 404, %{error: "Not Found"})
      {:unknown_status} -> send_json(conn, 404, %{error: "Not Found"})
      {:timeout, message} -> send_json(conn, 408, %{error: message})
      {:error, message} -> send_json(conn, 500, %{error: message})
      _ ->  send_json(conn, 500, %{error: "Unknown Error"})
    end
  end
end
