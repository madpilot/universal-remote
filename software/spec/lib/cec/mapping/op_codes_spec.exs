defmodule CEC.Mapping.OpCodesSpec do
  use ESpec
  alias CEC.Mapping.OpCodes

  describe "source code mappings" do
    it "maps feature_abort" do
      expect(OpCodes.op_codes[:feature_abort]) |> to(eq(0x0))
    end

    it "maps image_view_on" do
      expect(OpCodes.op_codes[:image_view_on]) |> to(eq(0x4))
    end

    it "maps tuner_step_increment" do
      expect(OpCodes.op_codes[:tuner_step_increment]) |> to(eq(0x5))
    end

    it "maps tuner_step_decrement" do
      expect(OpCodes.op_codes[:tuner_step_decrement]) |> to(eq(0x6))
    end

    it "maps tuner_device_status" do
      expect(OpCodes.op_codes[:tuner_device_status]) |> to(eq(0x7))
    end

    it "maps give_tuner_device_status" do
      expect(OpCodes.op_codes[:give_tuner_device_status]) |> to(eq(0x8))
    end

    it "maps record_on" do
      expect(OpCodes.op_codes[:record_on]) |> to(eq(0x9))
    end

    it "maps record_status" do
      expect(OpCodes.op_codes[:record_status]) |> to(eq(0xa))
    end

    it "maps record_off" do
      expect(OpCodes.op_codes[:record_off]) |> to(eq(0xb))
    end

    it "maps text_view_on" do
      expect(OpCodes.op_codes[:text_view_on]) |> to(eq(0xd))
    end

    it "maps record_tv_screen" do
      expect(OpCodes.op_codes[:record_tv_screen]) |> to(eq(0xf))
    end

    it "maps give_deck_status" do
      expect(OpCodes.op_codes[:give_deck_status]) |> to(eq(0x1a))
    end

    it "maps deck_status" do
      expect(OpCodes.op_codes[:deck_status]) |> to(eq(0x1b))
    end

    it "maps set_menu_language" do
      expect(OpCodes.op_codes[:set_menu_language]) |> to(eq(0x32))
    end

    it "maps clear_analogue_timer" do
      expect(OpCodes.op_codes[:clear_analogue_timer]) |> to(eq(0x33))
    end

    it "maps set_analogue_timer" do
      expect(OpCodes.op_codes[:set_analogue_timer]) |> to(eq(0x34))
    end

    it "maps timer_status" do
      expect(OpCodes.op_codes[:timer_status]) |> to(eq(0x35))
    end

    it "maps standby" do
      expect(OpCodes.op_codes[:standby]) |> to(eq(0x36))
    end

    it "maps play" do
      expect(OpCodes.op_codes[:play]) |> to(eq(0x41))
    end

    it "maps deck_control" do
      expect(OpCodes.op_codes[:deck_control]) |> to(eq(0x42))
    end

    it "maps timer_cleared_status" do
      expect(OpCodes.op_codes[:timer_cleared_status]) |> to(eq(0x43))
    end

    it "maps user_pressed" do
      expect(OpCodes.op_codes[:user_pressed]) |> to(eq(0x44))
    end

    it "maps user_released" do
      expect(OpCodes.op_codes[:user_released]) |> to(eq(0x45))
    end

    it "maps give_osd_name" do
      expect(OpCodes.op_codes[:give_osd_name]) |> to(eq(0x46))
    end

    it "maps set_osd_name" do
      expect(OpCodes.op_codes[:set_osd_name]) |> to(eq(0x47))
    end

    it "maps set_osd_string" do
      expect(OpCodes.op_codes[:set_osd_string]) |> to(eq(0x64))
    end

    it "maps set_timer_program_title" do
      expect(OpCodes.op_codes[:set_timer_program_title]) |> to(eq(0x67))
    end

    it "maps system_audio_mode_request" do
      expect(OpCodes.op_codes[:system_audio_mode_request]) |> to(eq(0x70))
    end

    it "maps give_audio_status" do
      expect(OpCodes.op_codes[:give_audio_status]) |> to(eq(0x71))
    end

    it "maps set_system_audio_mode" do
      expect(OpCodes.op_codes[:set_system_audio_mode]) |> to(eq(0x72))
    end

    it "maps report_audio_status" do
      expect(OpCodes.op_codes[:report_audio_status]) |> to(eq(0x7a))
    end

    it "maps give_system_audio_mode_status" do
      expect(OpCodes.op_codes[:give_system_audio_mode_status]) |> to(eq(0x7d))
    end

    it "maps system_audio_mode_status" do
      expect(OpCodes.op_codes[:system_audio_mode_status]) |> to(eq(0x7e))
    end

    it "maps routing_change" do
      expect(OpCodes.op_codes[:routing_change]) |> to(eq(0x80))
    end

    it "maps routing_information" do
      expect(OpCodes.op_codes[:routing_information]) |> to(eq(0x81))
    end

    it "maps active_source" do
      expect(OpCodes.op_codes[:active_source]) |> to(eq(0x82))
    end

    it "maps give_physical_address" do
      expect(OpCodes.op_codes[:give_physical_address]) |> to(eq(0x83))
    end

    it "maps report_physical_address" do
      expect(OpCodes.op_codes[:report_physical_address]) |> to(eq(0x84))
    end

    it "maps request_active_source" do
      expect(OpCodes.op_codes[:request_active_source]) |> to(eq(0x85))
    end

    it "maps set_stream_path" do
      expect(OpCodes.op_codes[:set_stream_path]) |> to(eq(0x86))
    end

    it "maps device_vendor_id" do
      expect(OpCodes.op_codes[:device_vendor_id]) |> to(eq(0x87))
    end

    it "maps vendor_command" do
      expect(OpCodes.op_codes[:vendor_command]) |> to(eq(0x89))
    end

    it "maps vendor_remote_button_down" do
      expect(OpCodes.op_codes[:vendor_remote_button_down]) |> to(eq(0x8a))
    end

    it "maps vendor_remote_button_up" do
      expect(OpCodes.op_codes[:vendor_remote_button_up]) |> to(eq(0x8b))
    end

    it "maps give_device_vendor_id" do
      expect(OpCodes.op_codes[:give_device_vendor_id]) |> to(eq(0x8c))
    end

    it "maps menu_request" do
      expect(OpCodes.op_codes[:menu_request]) |> to(eq(0x8d))
    end

    it "maps menu_status" do
      expect(OpCodes.op_codes[:menu_status]) |> to(eq(0x8e))
    end

    it "maps give_device_power_status" do
      expect(OpCodes.op_codes[:give_device_power_status]) |> to(eq(0x8f))
    end

    it "maps report_power_status" do
      expect(OpCodes.op_codes[:report_power_status]) |> to(eq(0x90))
    end

    it "maps get_menu_language" do
      expect(OpCodes.op_codes[:get_menu_language]) |> to(eq(0x91))
    end

    it "maps set_analogue_service" do
      expect(OpCodes.op_codes[:set_analogue_service]) |> to(eq(0x92))
    end

    it "maps select_digital_service" do
      expect(OpCodes.op_codes[:select_digital_service]) |> to(eq(0x93))
    end

    it "maps set_digital_timer" do
      expect(OpCodes.op_codes[:set_digital_timer]) |> to(eq(0x97))
    end

    it "maps clear_digital_timer" do
      expect(OpCodes.op_codes[:clear_digital_timer]) |> to(eq(0x99))
    end

    it "maps set_audio_rate" do
      expect(OpCodes.op_codes[:set_audio_rate]) |> to(eq(0x9a))
    end

    it "maps inactive_source" do
      expect(OpCodes.op_codes[:inactive_source]) |> to(eq(0x9d))
    end

    it "maps cec_version" do
      expect(OpCodes.op_codes[:cec_version]) |> to(eq(0x9e))
    end

    it "maps get_cec_version" do
      expect(OpCodes.op_codes[:get_cec_version]) |> to(eq(0x9f))
    end

    it "maps vendor_command_with_id" do
      expect(OpCodes.op_codes[:vendor_command_with_id]) |> to(eq(0xa0))
    end

    it "maps clear_external_timer" do
      expect(OpCodes.op_codes[:clear_external_timer]) |> to(eq(0xa1))
    end

    it "maps set_external_timer" do
      expect(OpCodes.op_codes[:set_external_timer]) |> to(eq(0xa2))
    end

    it "maps abort" do
      expect(OpCodes.op_codes[:abort]) |> to(eq(0xff))
    end
  end

  describe("to_code") do
    it "maps the opcode name to the relevant code" do
      expect(OpCodes.to_code(:play)) |> to(eq(0x41))
    end
  end

  describe("from_code") do
    it "maps the code to the opcode name" do
      expect(OpCodes.from_code(0x64)) |> to(eq(:set_osd_string))
    end
  end
end
