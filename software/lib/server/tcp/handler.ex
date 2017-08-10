defmodule Server.TCP.Handler do
  use GenStage

  def start_link(ref, socket, transport, opts) do
    GenStage.start_link(__MODULE__, {socket, transport})
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init({socket, transport}) do
    IO.puts "Init GenStage"
    {:consumer, {socket, transport}, subscribe_to: [CEC.Producer, LIRC.Producer]}
  end

  def init(ref, socket, transport, _Opts = []) do
    :ok = :ranch.accept_ack(ref)
    loop(socket, transport)
  end

  def handle_events(events, _from, state) do
    {socket, transport} = state

    events
    |> Enum.each(fn(ev) ->
      packet = ev
      |> Poison.encode!

      transport.send(socket, "#{packet}\n")
    end)

    {:noreply, [], state}
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 5000) do
      {:ok, data} ->
        transport.send(socket, data)
        loop(socket, transport)
      _ ->
        :ok = transport.close(socket)
    end
  end
end
