defmodule CEC.Parsers.ParserSpec do
  use ESpec

  alias CEC.Parsers.Parser

  describe "abort" do
    it "parses message" do
      expect(Parser.from_code("01:FF")) |> to(eq %{source: :tv, destination: :recording_1, command: :abort})
    end
  end

  describe "active_source" do
    it "parses message" do
      expect(Parser.from_code("60:82:31:00")) |> to(eq %{source: :tuner_2, destination: :tv, command: :active_source, address: "3.1.0.0"})
    end
  end

  describe "cec_version" do
    it "parses message" do
      expect(Parser.from_code("60:9E:01")) |> to(eq %{source: :tuner_2, destination: :tv, command: :cec_version, version: "1.2"})
    end
  end

  describe "deck_control" do
    it "parses message" do
      expect(Parser.from_code("08:42:03")) |> to(eq %{source: :tv, destination: :playback_2, command: :deck_control, mode: :stop})
    end
  end

  describe "deck_status" do
    it "parses message" do
      expect(Parser.from_code("28:1B:14")) |> to(eq %{source: :recording_2, destination: :playback_2, command: :deck_status, status: :still})
    end
  end

  describe "device_vendor_id" do
    it "parses message" do
      expect(Parser.from_code("90:87:00:00:F0")) |> to(eq %{source: :playback_3, destination: :tv, command: :device_vendor_id, vendor: :samsung})
    end
  end

  describe "feature_abort" do
    it "parses message" do
      expect(Parser.from_code("90:00:85:01")) |> to(eq %{source: :playback_3, destination: :tv, command: :feature_abort, op_code: :request_active_source, reason: :not_in_correct_mode_to_respond})
    end
  end

  describe "get_cec_version" do
    it "parses message" do
      expect(Parser.from_code("69:9F")) |> to(eq %{source: :tuner_2, destination: :playback_3, command: :get_cec_version})
    end
  end

  describe "get_menu_language" do
    it "parses message" do
      expect(Parser.from_code("69:91")) |> to(eq %{source: :tuner_2, destination: :playback_3, command: :get_menu_language})
    end
  end

  describe "give_audio_status" do
    it "parses message" do
      expect(Parser.from_code("F5:71")) |> to(eq %{source: :unregistered, destination: :audio_system, command: :give_audio_status})
    end
  end

  describe "give_device_power_status" do
    it "parses message" do
      expect(Parser.from_code("6A:8F")) |> to(eq %{source: :tuner_2, destination: :tuner_4, command: :give_device_power_status})
    end
  end

  describe "give_device_vendor_id" do
    it "parses message" do
      expect(Parser.from_code("6A:8C")) |> to(eq %{source: :tuner_2, destination: :tuner_4, command: :give_device_vendor_id})
    end
  end
end
