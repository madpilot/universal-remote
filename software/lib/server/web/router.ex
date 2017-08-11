# There are three parts to the rest API:
#
# 1. The remote control: /remote
# 2. Raw device commands /devices
# 3. Websockets /ws

defmodule Server.Web.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "index")
  end

  forward "/remotes", to: Server.Web.Remotes.Router

  match _ do
    send_resp(conn, 404, "oops")
  end
end
