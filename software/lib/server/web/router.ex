# There are two parts to the rest API:
#
# 1. The remote control: /remote
# 2. Raw device commands /devices

defmodule Server.Web.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "<html><head><script>var socket=new WebSocket('ws://localhost:4001/ws');setInterval(function() { socket.send('ping'); }, 30000);socket.addEventListener('open', function (event) {socket.send(JSON.stringify({channel:'devices',action:'get_devices'}));});socket.addEventListener('message', function (event) {console.log('Message from server:', event.data);});</script></head><body></body></html>")
  end

  forward "/remotes", to: Server.Web.Remotes.Router
  forward "/devices", to: Server.Web.Devices.Router

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, %{error: "Not Found"} |> Poison.encode!)
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status, %{error: "Something went wrong"} |> Poison.encode!)
  end
end
