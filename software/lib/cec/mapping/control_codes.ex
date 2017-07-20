defmodule CEC.Mapping.ControlCodes do
  def controls do
    [
      select: 0x00,
      up: 0x01,
      down: 0x02,
      left: 0x03,
      right: 0x04,
      right_up: 0x05,
      right_down: 0x06,
      left_up: 0x07,
      left_down: 0x08,
      root_menu: 0x09,
      setup_menu: 0x0A,
      contents_menu: 0x0B,
      favourite_menu: 0x0C,
      exit: 0x0D,
      num_0: 0x20,
      num_1: 0x21,
      num_2: 0x22,
      num_3: 0x23,
      num_4: 0x24,
      num_5: 0x25,
      num_6: 0x26,
      num_7: 0x27,
      num_8: 0x28,
      num_9: 0x29,
      dot: 0x2A,
      enter: 0x2B,
      clear: 0x2C,
      next_favourite: 0x2F,
      channel_up: 0x30,
      channel_down: 0x31,
      previous_channel: 0x32,
      sound_select: 0x33,
      input_select: 0x34,
      display_information: 0x35,
      help: 0x36,
      page_up: 0x37,
      page_down: 0x38,
      power: 0x40,
      volume_up: 0x41,
      volume_down: 0x42,
      mute: 0x43,
      play: 0x44,
      stop: 0x45,
      pause: 0x46,
      record: 0x47,
      rewind: 0x48,
      fast_forward: 0x49,
      eject: 0x4A,
      forward: 0x4B,
      backward: 0x4C,
      stop_record: 0x4D,
      pause_record: 0x4E,
      angle: 0x50,
      sub_picture: 0x51,
      video_on_demand: 0x52,
      electronic_program_guide: 0x53,
      timer_programming: 0x54,
      initial_configuration: 0x55,
      play_function: 0x60,
      play_pause_function: 0x61,
      record_function: 0x62,
      pause_record_function: 0x63,
      stop_function: 0x64,
      mute_function: 0x65,
      restore_volume_function: 0x66,
      tune_function: 0x67,
      select_media_function: 0x68,
      select_av_input_function: 0x69,
      select_audio_function: 0x6A,
      power_toggle_function: 0x6B,
      power_off_function: 0x6C,
      power_on_function: 0x6D,
      blue: 0x71,
      red: 0x72,
      green: 0x73,
      yellow: 0x74,
      f1: 0x71,
      f2: 0x72,
      f3: 0x73,
      f4: 0x74,
      f5: 0x75
    ]
  end

  def control_to_code(control) do
    controls()[control]
  end

  def code_to_control(code) do
    result = for control <- controls(), 
        fn(control, code) -> control 
                            |> elem(1) == code
        end.(control, code), do: control
    
    case result do
      [{control, _}] -> control
            [] -> nil
    end
  end
end
