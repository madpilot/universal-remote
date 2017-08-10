defmodule Server.TCP.Worker do
  def start_link do
    opts = [port: 4242]
    {:ok, _} = :ranch.start_listener(:TCP, 100, :ranch_tcp, opts, Server.TCP.Handler, [])
  end
end
