defmodule Server.TCP.Server do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, socket} = :gen_tcp.listen(4242, [:binary, packet: :line, active: false, reuseaddr: true])
    {:ok, client} = :gen_tcp.accept(socket)
    {:consumer, %{client: client}, subscribe_to: [CEC.Producer, LIRC.Producer]}
  end

  defp send_packet(obj, socket) do
    :gen_tcp.send(socket, "#{obj}\n")
  end

  def handle_events(events, _from, state) do
    events
    |> Enum.each(fn(ev) -> ev |> Poison.encode! |> Apex.ap |> send_packet(state[:client]) end)
    {:noreply, [], state}
  end
end
