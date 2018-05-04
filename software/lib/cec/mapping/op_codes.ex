defmodule CEC.Mapping.OpCodes do
  alias CEC.Mapping.Mapper

  def op_codes do
    [
      feature_abort: 0x00,
      image_view_on: 0x04,
      tuner_step_increment: 0x05,
      tuner_step_decrement: 0x06,
      tuner_device_status: 0x07,
      give_tuner_device_status: 0x08,
      record_on: 0x09,
      record_status: 0x0a,
      record_off: 0x0b,
      text_view_on: 0x0d,
      record_tv_screen: 0x0f,

      give_deck_status: 0x1a,
      deck_status: 0x1b,

      set_menu_language: 0x32,
      clear_analogue_timer: 0x33,
      set_analogue_timer: 0x34,
      timer_status: 0x35,
      standby: 0x36,

      play: 0x41,
      deck_control: 0x42,
      timer_cleared_status: 0x43,
      user_pressed: 0x44,
      user_released: 0x45,
      give_osd_name: 0x46,
      set_osd_name: 0x47,

      set_osd_string: 0x64,
      set_timer_program_title: 0x67,

      system_audio_mode_request: 0x70,
      give_audio_status: 0x71,
      set_system_audio_mode: 0x72,
      report_audio_status: 0x7A,
      give_system_audio_mode_status: 0x7D,
      system_audio_mode_status: 0x7E,

      routing_change: 0x80,
      routing_information: 0x81,
      active_source: 0x82,
      give_physical_address: 0x83,
      report_physical_address: 0x84,
      request_active_source: 0x85,
      set_stream_path: 0x86,
      device_vendor_id: 0x87,
      vendor_command: 0x89,
      vendor_remote_button_down: 0x8a,
      vendor_remote_button_up: 0x8b,
      give_device_vendor_id: 0x8c,
      menu_request: 0x8d,
      menu_status: 0x8e,
      give_device_power_status: 0x8f,

      report_power_status: 0x90,
      get_menu_language: 0x91,
      set_analogue_service: 0x92,
      select_digital_service: 0x93,
      set_digital_timer: 0x97,
      clear_digital_timer: 0x99,
      set_audio_rate: 0x9a,
      inactive_source: 0x9d,
      cec_version: 0x9e,
      get_cec_version: 0x9f,

      vendor_command_with_id: 0xa0,
      clear_external_timer: 0xa1,
      set_external_timer: 0xa2,

      abort: 0xff
    ]
  end

  def to_code(control) do
    op_codes()
    |> Mapper.to_code(control)
  end

  def from_code(code) do
    op_codes()
    |> Mapper.from_code(code)
  end
end
