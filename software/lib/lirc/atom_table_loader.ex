defmodule LIRC.AtomTableLoader do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [:ok], name: __MODULE__)
  end

  def init(state) do
    send(self(), :work)
    {:ok, state}
  end

  def handle_info(:work, state) do
    LIRC.Process.list_devices()
      |> elem(1)
      |> Enum.each(&LIRC.Process.list_commands(&1))

    {:stop, :normal, state}
  end
end
