defmodule CEC.MappingSpec do
  use ESpec
  alias CEC.Mapping

  describe "device code mappings" do
    it "maps tv" do
      expect(Mapping.devices[:tv]) |> to(eq("00"))
    end

    it "maps recording_1" do
      expect(Mapping.devices[:recording_1]) |> to(eq("01"))
    end
    
    it "maps recording_2" do
      expect(Mapping.devices[:recording_2]) |> to(eq("02"))
    end
    
    it "maps tuner_1" do
      expect(Mapping.devices[:tuner_1]) |> to(eq("03"))
    end
    
    it "maps tuner_2" do
      expect(Mapping.devices[:tuner_2]) |> to(eq("06"))
    end
    
    it "maps tuner_3" do
      expect(Mapping.devices[:tuner_3]) |> to(eq("07"))
    end
    
    it "maps tuner_4" do
      expect(Mapping.devices[:tuner_4]) |> to(eq("0A"))
    end
    
    it "maps playback_1" do
      expect(Mapping.devices[:playback_1]) |> to(eq("04"))
    end
    
    it "maps playback_2" do
      expect(Mapping.devices[:playback_2]) |> to(eq("08"))
    end
    
    it "maps playback_3" do
      expect(Mapping.devices[:playback_3]) |> to(eq("09"))
    end
    
    it "maps playback_4" do
      expect(Mapping.devices[:playback_4]) |> to(eq("0B"))
    end
    
    it "maps audio_system" do
      expect(Mapping.devices[:audio_system]) |> to(eq("05"))
    end
    
    it "maps reserved_c" do
      expect(Mapping.devices[:reserved_c]) |> to(eq("0C"))
    end
    
    it "maps reserved_d" do
      expect(Mapping.devices[:reserved_d]) |> to(eq("0D"))
    end
    
    it "maps reserved_e" do
      expect(Mapping.devices[:reserved_e]) |> to(eq("0E"))
    end
    
    it "maps braodcast" do
      expect(Mapping.devices[:broadcast]) |> to(eq("0F"))
    end
  end

  describe("device_to_code") do
    it "maps the device name to the relevant code" do
      expect(Mapping.device_to_code(:tv)) |> to(eq("00"))
    end
  end

  describe("code_to_device") do
    it "maps the code to the device name" do
      expect(Mapping.code_to_device("00")) |> to(eq(:tv))
    end

    it "maps to nil of the code doesn't exist" do
      expect(Mapping.code_to_device("100")) |> to(eq(nil))
    end
  end
end
