# There are two parts to the rest API:
#
# 1. The remote control: /remote
# 2. Raw device commands /devices

defmodule Server.Web.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "index")
  end

  forward "/remotes", to: Server.Web.Remotes.Router
  forward "/devices", to: Server.Web.Devices.Router

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
