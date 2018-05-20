# There are two parts to the rest API:
#
# 1. The remote control: /remote
# 2. Raw device commands /devices

defmodule Server.Web.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "<html><head><script>var socket=new WebSocket('ws://localhost:4001/ws');socket.addEventListener('open', function (event) {socket.send(JSON.stringify({bus:'devices',action:'get_devices'}));});socket.addEventListener('message', function (event) {console.log('Message from server ', event.data);});</script></head><body></body></html>")
  end

  forward "/remotes", to: Server.Web.Remotes.Router
  forward "/devices", to: Server.Web.Devices.Router

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
