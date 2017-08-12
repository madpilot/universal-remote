defmodule CEC.RemoteSpec do
  use ESpec

  describe "devices" do
    subject do: CEC.Remote.devices()

    it "returns a set of devices" do
      {:ok, devices} = subject()
      expect(devices) |> to(eq([:tv, :recording_1, :recording_2, :tuner_1, :playback_1, :audio_system, :tuner_2, :tuner_3, :playback_2, :playback_3, :tuner_4, :playback_4, :reserved_c, :reserved_d, :reserved_e, :broadcast]))
    end
  end

  describe "commands" do
    let :device, do: :tv

    subject do: CEC.Remote.commands(device())

    let :commands, do: [:select, :up, :down, :left, :right, :right_up,
      :right_down, :left_up, :left_down, :root_menu, :setup_menu,
      :contents_menu, :favourite_menu, :exit,
      :num_0, :num_1, :num_2, :num_3, :num_4, :num_5, :num_6, :num_7, :num_8, :num_9, :dot,
      :enter, :clear, :next_favourite,
      :channel_up, :channel_down, :previous_channel, :sound_select, :input_select,
      :display_information, :help,:page_up, :page_down, :power, :volume_up,
      :volume_down, :mute, :play, :stop, :pause, :record, :rewind, :fast_forward, :eject,
      :forward, :backward, :stop_record, :pause_record,
      :angle, :sub_picture, :video_on_demand, :electronic_program_guide,
      :timer_programming, :initial_configuration, :play_function,
      :play_pause_function, :record_function, :pause_record_function,
      :stop_function, :mute_function, :restore_volume_function,
      :tune_function, :select_media_function, :select_av_input_function, :select_audio_function,
      :power_toggle_function, :power_off_function, :power_on_function,
      :blue, :red, :green, :yellow, :f1, :f2, :f3, :f4, :f5, :data]

    it "returns a set of keys" do
      {:ok, devices} = subject()
      expect(devices) |> to(eq(commands()))
    end
  end
end
