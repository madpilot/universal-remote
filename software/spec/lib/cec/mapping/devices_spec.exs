defmodule CEC.Mapping.DevicesSpec do
  use ESpec
  alias CEC.Mapping.Devices

  describe "device code mappings" do
    it "maps tv" do
      expect(Devices.devices[:tv]) |> to(eq(0x0))
    end

    it "maps recording_1" do
      expect(Devices.devices[:recording_1]) |> to(eq(0x1))
    end

    it "maps recording_2" do
      expect(Devices.devices[:recording_2]) |> to(eq(0x2))
    end

    it "maps tuner_1" do
      expect(Devices.devices[:tuner_1]) |> to(eq(0x3))
    end

    it "maps tuner_2" do
      expect(Devices.devices[:tuner_2]) |> to(eq(0x6))
    end

    it "maps tuner_3" do
      expect(Devices.devices[:tuner_3]) |> to(eq(0x7))
    end

    it "maps tuner_4" do
      expect(Devices.devices[:tuner_4]) |> to(eq(0xA))
    end

    it "maps playback_1" do
      expect(Devices.devices[:playback_1]) |> to(eq(0x4))
    end

    it "maps playback_2" do
      expect(Devices.devices[:playback_2]) |> to(eq(0x8))
    end

    it "maps playback_3" do
      expect(Devices.devices[:playback_3]) |> to(eq(0x9))
    end

    it "maps playback_4" do
      expect(Devices.devices[:playback_4]) |> to(eq(0xB))
    end

    it "maps audio_system" do
      expect(Devices.devices[:audio_system]) |> to(eq(0x5))
    end

    it "maps reserved_c" do
      expect(Devices.devices[:reserved_c]) |> to(eq(0xC))
    end

    it "maps reserved_d" do
      expect(Devices.devices[:reserved_d]) |> to(eq(0xD))
    end

    it "maps reserved_e" do
      expect(Devices.devices[:reserved_e]) |> to(eq(0xE))
    end

    it "maps braodcast" do
      expect(Devices.devices[:broadcast]) |> to(eq(0xF))
    end
  end

  describe("to_code") do
    it "maps the device name to the relevant code" do
      expect(Devices.to_code(:tv)) |> to(eq(0x0))
    end
  end

  describe("from_code") do
    it "maps the code to the device name" do
      expect(Devices.from_code(0x0)) |> to(eq(:tv))
    end

    it "maps to nil of the code doesn't exist" do
      expect(Devices.from_code(0x100)) |> to(eq(nil))
    end
  end
end
