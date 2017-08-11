defmodule Server.Web.Devices.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "devices")
  end
end
