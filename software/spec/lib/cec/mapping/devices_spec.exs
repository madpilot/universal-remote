defmodule CEC.Mapping.DevicesSpec do
  use ESpec
  alias CEC.Mapping.Devices

  describe "device code mappings" do
    it "maps tv" do
      expect(Devices.devices[:tv]) |> to(eq(0x00))
    end

    it "maps recording_1" do
      expect(Devices.devices[:recording_1]) |> to(eq(0x01))
    end
    
    it "maps recording_2" do
      expect(Devices.devices[:recording_2]) |> to(eq(0x02))
    end
    
    it "maps tuner_1" do
      expect(Devices.devices[:tuner_1]) |> to(eq(0x03))
    end
    
    it "maps tuner_2" do
      expect(Devices.devices[:tuner_2]) |> to(eq(0x06))
    end
    
    it "maps tuner_3" do
      expect(Devices.devices[:tuner_3]) |> to(eq(0x07))
    end
    
    it "maps tuner_4" do
      expect(Devices.devices[:tuner_4]) |> to(eq(0x0A))
    end
    
    it "maps playback_1" do
      expect(Devices.devices[:playback_1]) |> to(eq(0x04))
    end
    
    it "maps playback_2" do
      expect(Devices.devices[:playback_2]) |> to(eq(0x08))
    end
    
    it "maps playback_3" do
      expect(Devices.devices[:playback_3]) |> to(eq(0x09))
    end
    
    it "maps playback_4" do
      expect(Devices.devices[:playback_4]) |> to(eq(0x0B))
    end
    
    it "maps audio_system" do
      expect(Devices.devices[:audio_system]) |> to(eq(0x05))
    end
    
    it "maps reserved_c" do
      expect(Devices.devices[:reserved_c]) |> to(eq(0x0C))
    end
    
    it "maps reserved_d" do
      expect(Devices.devices[:reserved_d]) |> to(eq(0x0D))
    end
    
    it "maps reserved_e" do
      expect(Devices.devices[:reserved_e]) |> to(eq(0x0E))
    end
    
    it "maps braodcast" do
      expect(Devices.devices[:broadcast]) |> to(eq(0x0F))
    end
  end

  describe("device_to_code") do
    it "maps the device name to the relevant code" do
      expect(Devices.device_to_code(:tv)) |> to(eq(0x00))
    end
  end

  describe("code_to_device") do
    it "maps the code to the device name" do
      expect(Devices.code_to_device(0x00)) |> to(eq(:tv))
    end

    it "maps to nil of the code doesn't exist" do
      expect(Devices.code_to_device(0x100)) |> to(eq(nil))
    end
  end
end
