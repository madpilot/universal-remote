defmodule LIRC.RemoteSpec do
  use ESpec

  describe "devices" do
    subject do: LIRC.Remote.devices()
    before do: allow System |> to(accept :cmd, fn(_, ["list", "", ""]) -> {"irsend: foxtel\nirsend: tv\nirsend: receiver", 0} end)

    it "returns a set of devices" do
      {:ok, devices} = subject()
      expect(devices) |> to(eq([:foxtel, :tv, :receiver]))
    end
  end

  describe "commands" do
    let :device, do: :foxtel

    subject do: LIRC.Remote.commands(device())
    before do: allow System |> to(accept :cmd, fn(_, ["list", "foxtel", ""]) -> {"irsend: 0000000000000001 KEY_0\nirsend: 0000000000000002 KEY_1\nirsend: 0000000000000003 KEY_2", 0} end)

    it "returns a set of keys" do
      {:ok, devices} = subject()
      expect(devices) |> to(eq([:key_0, :key_1, :key_2]))
    end
  end

  describe "sending a single command" do
    before do: allow System |> to(accept :cmd, fn(_, _) -> {"", 0} end)
    subject do: LIRC.Remote.send_once(:foxtel, :key_volumeup)

    it "send the command code to the port" do
      [irsend: irsend, irw: _] = Application.get_env(:universal_remote, LIRC.Process)
      {:ok} = subject()
      expect(System) |> to(accepted :cmd, [irsend, ["send_once", "foxtel", "KEY_VOLUMEUP"]])
    end
  end

  describe "sending a start command" do
    before do: allow System |> to(accept :cmd, fn(_, _) -> {"", 0} end)
    subject do: LIRC.Remote.send_start(:foxtel, :key_volumeup)

    it "send the command code to the port" do
      [irsend: irsend, irw: _] = Application.get_env(:universal_remote, LIRC.Process)
      {:ok} = subject()
      expect(System) |> to(accepted :cmd, [irsend, ["send_start", "foxtel", "KEY_VOLUMEUP"]])
    end
  end

  describe "sending a stop command" do
    before do: allow System |> to(accept :cmd, fn(_, _) -> {"", 0} end)
    subject do: LIRC.Remote.send_stop(:foxtel, :key_volumeup)

    it "send the command code to the port" do
      [irsend: irsend, irw: _] = Application.get_env(:universal_remote, LIRC.Process)
      {:ok} = subject()
      expect(System) |> to(accepted :cmd, [irsend, ["send_stop", "foxtel", "KEY_VOLUMEUP"]])
    end
  end
end
