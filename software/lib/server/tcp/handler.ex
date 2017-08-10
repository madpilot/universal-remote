defmodule Server.TCP.Handler do
  use GenStage

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init({socket, transport}) do
    {:consumer, {socket, transport}, subscribe_to: [CEC.Producer, LIRC.Producer]}
  end

  def init(ref, socket, transport, _Opts = []) do
    :ok = :ranch.accept_ack(ref)
    GenStage.start_link(__MODULE__, {socket, transport})
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

  def parse_event(data) do
    case data |> Poison.decode! do
      %{"bus" => "lirc", "destination" => destination, "command" => command} ->
        LIRC.Process.send_command(destination |> String.to_atom, command |> String.to_atom)
      _ -> nil
    end
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 3000) do
      {:ok, data} ->
        data
        |> parse_event

        loop(socket, transport)
      {:error, :timeout} -> loop(socket, transport)
    end
  end
end
