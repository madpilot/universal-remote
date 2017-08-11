defmodule Server.Web.Remotes.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, [:cec, :lirc] |> Poison.encode!)
  end

  get "/:bus" do
    case bus do
      "cec" -> conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, CEC.Mapping.Destination.devices |> Enum.map(fn(k) -> k |> elem(0) end) |> Poison.encode!)
      _ -> send_resp(conn, 404, "Not found")
    end
  end

  get "/:bus/:device" do
    case bus do
      "cec" -> conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, CEC.Mapping.ControlCodes.controls |> Enum.map(fn(k) -> k |> elem(0) end) |> Poison.encode!)
      _ -> send_resp(conn, 404, "Not found")
    end
  end

  get "/:bus/:device/send" do
  end
end
