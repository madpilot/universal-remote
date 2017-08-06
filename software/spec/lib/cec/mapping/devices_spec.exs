defmodule CEC.Mapping.DevicesSpec do
  use ESpec
  alias CEC.Mapping.Devices

  describe "source code mappings" do
    it "maps tv" do
      expect(Devices.devices[:tv]) |> to(eq(0x0))
    end

    it "maps recording" do
      expect(Devices.devices[:recording]) |> to(eq(0x1))
    end

    it "maps tuner" do
      expect(Devices.devices[:tuner]) |> to(eq(0x3))
    end

    it "maps playback" do
      expect(Devices.devices[:playback]) |> to(eq(0x4))
    end

    it "maps audio_system" do
      expect(Devices.devices[:audio_system]) |> to(eq(0x5))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(Devices.to_code(:recording)) |> to(eq(0x1))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(Devices.from_code(0x2)) |> to(eq(:reserved))
    end
  end
end
