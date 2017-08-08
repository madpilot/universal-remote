defmodule LIRC.ProcessSpec do
  use ESpec

  describe "receiving lines from the port" do
    before do: allow GenServer |> to(accept :cast, fn(_, _) -> nil end)

    it "is cast to LIRC.Producer" do
      expect(LIRC.Process.handle_info({:ok, {:data, {:eol, "test"}}}, :state)) |> to(eq({:noreply, :state}))
      expect(GenServer) |> to(accepted :cast, [LIRC.Producer, {:lirc, "test"}])
    end
  end

  # describe "sending a lirc command" do
  #   let port: self()

  #   it "send the command code to the port" do
  #     CEC.Process.handle_call({:send_code, "00:11"}, self(), %{port: port()})
  #     assert_receive({_, {:command, "tx 00:11\n"}})
  #   end

  #   describe "#send_code" do
  #     before do: allow GenServer |> to(accept :call, fn(_, _) -> nil end)
  #     it "sends the command code to the port" do
  #       CEC.Process.send_code("00:11")
  #       expect(GenServer) |> to(accepted :call, [CEC.Process, {:send_code, "00:11"}])
  #     end
  #   end
  # end

  describe "list_devices" do
    subject do: LIRC.Process.list_devices()
    before do: allow System |> to(accept :cmd, fn(_, ["list", "", ""]) -> {"irsend: foxtel\nirsend: tv\nirsend: receiver", 0} end)

    it "returns a set of devices" do
      {:ok, devices} = subject()
      expect(devices) |> to(eq([:foxtel, :tv, :receiver]))
    end
  end

  describe "list_commands" do
    let :device, do: :foxtel

    subject do: LIRC.Process.list_commands(device())
    before do: allow System |> to(accept :cmd, fn(_, ["list", "foxtel", ""]) -> {"irsend: 0000000000000001 KEY_0\nirsend: 0000000000000002 KEY_1\nirsend: 0000000000000003 KEY_2", 0} end)

    it "returns a set of keys" do
      {:ok, devices} = subject()
      expect(devices) |> to(eq([:key_0, :key_1, :key_2]))
    end
  end
end
