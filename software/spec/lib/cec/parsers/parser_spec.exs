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

  describe "give_osd_name" do
    it "parses message" do
      expect(Parser.from_code("6A:46")) |> to(eq %{source: :tuner_2, destination: :tuner_4, command: :give_osd_name})
    end
  end

  describe "give_physical_address" do
    it "parses message" do
      expect(Parser.from_code("6A:83")) |> to(eq %{source: :tuner_2, destination: :tuner_4, command: :give_physical_address})
    end
  end

  describe "give_system_audio_mode_status" do
    it "parses message" do
      expect(Parser.from_code("65:7D")) |> to(eq %{source: :tuner_2, destination: :audio_system, command: :give_system_audio_mode_status})
    end
  end

  describe "give_tuner_device_status" do
    it "parses message"
  end

  describe "image_view_on" do
    it "parses message" do
      expect(Parser.from_code("20:04")) |> to(eq %{source: :recording_2, destination: :tv, command: :image_view_on})
    end
  end

  describe "inactive_source" do
    it "parses message" do
      expect(Parser.from_code("20:9D:11:12")) |> to(eq %{source: :recording_2, destination: :tv, command: :inactive_source, address: "1.1.1.2"})
    end
  end

  describe "menu_request" do
    it "parses message" do
      expect(Parser.from_code("04:8D:01")) |> to(eq %{source: :tv, destination: :playback_1, command: :menu_request, type: :deactivate})
    end
  end

  describe "menu_status" do
    it "parses message" do
      expect(Parser.from_code("90:8E:00")) |> to(eq %{source: :playback_3, destination: :tv, command: :menu_status, state: :activated})
    end
  end

  describe "play" do
    it "parses message"
  end

  describe "polling" do
    it "parses message" do
      expect(Parser.from_code("04")) |> to(eq %{source: :tv, destination: :playback_1, command: :polling})
    end
  end

  describe "record_off" do
    it "parses message" do
      expect(Parser.from_code("02:0B")) |> to(eq %{source: :tv, destination: :recording_2, command: :record_off})
    end
  end

  describe "record_on" do
    it "parses message"
  end

  describe "record_status" do
    it "parses message"
  end

   describe "record_tv_screen" do
    it "parses message" do
      expect(Parser.from_code("02:0F")) |> to(eq %{source: :tv, destination: :recording_2, command: :record_tv_screen})
    end
  end

  describe "report_audio_status" do
    it "parses message" do
      expect(Parser.from_code("15:7A:2D")) |> to(eq %{source: :recording_1, destination: :audio_system, command: :report_audio_status, muted: false, volume: 45})
    end
  end

  describe "report_physical_address" do
    it "parses message" do
      expect(Parser.from_code("2F:84:34:21:01")) |> to(eq %{source: :recording_2, destination: :broadcast, command: :report_physical_address, address: "3.4.2.1", type: :recording})
    end
  end

  describe "request_active_source" do
    it "parses message" do
      expect(Parser.from_code("6F:85")) |> to(eq %{source: :tuner_2, destination: :broadcast, command: :request_active_source})
    end
  end

  describe "routing_change" do
    it "parses message" do
      expect(Parser.from_code("6F:80:32:11:32:13")) |> to(eq %{source: :tuner_2, destination: :broadcast, command: :routing_change, original_address: "3.2.1.1", new_address: "3.2.1.3"})
    end
  end

  describe "routing_information" do
    it "parses message" do
      expect(Parser.from_code("5F:81:31:22")) |> to(eq %{source: :audio_system, destination: :broadcast, command: :routing_information, address: "3.1.2.2"})
    end
  end

  describe "select_analogue_service" do
    it "parses message"
  end

  describe "select_digital_service" do
    it "parses message"
  end

  describe "set_analogue_timer" do
    it "parses message"
  end

  describe "set_audio_rate" do
    it "parses message"
  end

  describe "set_digital_timer" do
    it "parses message"
  end

  describe "set_external_timer" do
    it "parses message"
  end

  describe "set_menu_language" do
    it "parses message"
  end

  describe "set_osd_name" do
    it "parses message" do
      expect(Parser.from_code("A0:47:4A:6F:68:6E:20:57:65:73:74")) |> to(eq %{source: :tuner_4, destination: :tv, command: :set_osd_name, value: "John West"})
    end
  end

  describe "set_osd_string" do
    it "parses message"
  end

  describe "set_stream_path" do
    it "parses message"
  end

  describe "standby" do
    it "parses message" do
      expect(Parser.from_code("0F:36")) |> to(eq %{source: :tv, destination: :broadcast, command: :standby})
    end
  end

  describe "system_audio_mode_request" do
    it "parses message"
  end

  describe "system_audio_mode_status" do
    it "parses message"
  end

  describe "text_view_on" do
    it "parses message" do
      expect(Parser.from_code("20:0D")) |> to(eq %{source: :recording_2, destination: :tv, command: :text_view_on})
    end
  end

  describe "timer_cleared_status" do
    it "parses message"
  end

  describe "tuner_device_status" do
    it "parses message"
  end

  describe "tuner_step_decrement" do
    it "parses message" do
      expect(Parser.from_code("0F:06")) |> to(eq %{source: :tv, destination: :broadcast, command: :tuner_step_decrement})
    end
  end

  describe "tuner_step_increment" do
    it "parses message" do
      expect(Parser.from_code("0F:05")) |> to(eq %{source: :tv, destination: :broadcast, command: :tuner_step_increment})
    end
  end

  describe "user_pressed" do
    expect(Parser.from_code("2F:44:0C")) |> to(eq %{source: :recording_2, destination: :broadcast, command: :user_pressed, key: :favourite_menu})
  end

  describe "user_released" do
    expect(Parser.from_code("2F:45")) |> to(eq %{source: :recording_2, destination: :broadcast, command: :user_released})
  end

  describe "vendor_command" do
    it "parses message" do
      expect(Parser.from_code("2F:89:00:FF:34")) |> to(eq %{source: :recording_2, destination: :broadcast, command: :vendor_command, code: "00:FF:34"})
    end
  end

  describe "vendor_command_with_id" do
    it "parses message"
  end

  describe "vendor_remote_button_down" do
    it "parses message" do
      expect(Parser.from_code("2F:8A:00:FF:34")) |> to(eq %{source: :recording_2, destination: :broadcast, command: :vendor_remote_button_down, code: "00:FF:34"})
    end
  end

  describe "vendor_remote_button_up" do
    it "parses message" do
      expect(Parser.from_code("2F:8B")) |> to(eq %{source: :recording_2, destination: :broadcast, command: :vendor_remote_button_up})
    end
  end
end
