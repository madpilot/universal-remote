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

    context "device doesn't exist" do
      let :device, do: :foo

      it "returns an error" do
        expect(subject()) |> to(eq {:error, :not_a_device})
      end
    end
  end

  describe "sending" do
    before do: allow GenServer |> to(accept :cast, fn(_, _) -> nil end)

    describe "send_once" do
      it "sends a user press to the CEC bus" do
        CEC.Remote.send_once(:tv, :up)
        expect(GenServer) |> to(accepted :call, [CEC.Process, {:send_code, "F0:44:01"}])
      end

      context "device doesn't exist" do
        it "returns an error" do
          expect(CEC.Remote.send_once(:foo, :up)) |> to(eq {:error, :not_a_device})
        end
      end

      context "key doesn't exist" do
        it "returns an error" do
          expect(CEC.Remote.send_once(:tv, :foo)) |> to(eq {:error, :not_a_key})
        end
      end
    end

    describe "send_start" do
      it "sends a user press to the CEC bus" do
        CEC.Remote.send_start(:tv, :up)
        expect(GenServer) |> to(accepted :call, [CEC.Process, {:send_code, "F0:44:01"}])
      end

      context "device doesn't exist" do
        it "returns an error" do
          expect(CEC.Remote.send_start(:foo, :up)) |> to(eq {:error, :not_a_device})
        end
      end

      context "key doesn't exist" do
        it "returns an error" do
          expect(CEC.Remote.send_start(:tv, :foo)) |> to(eq {:error, :not_a_key})
        end
      end
    end

    describe "send_stop" do
      it "sends a user release to the CEC bus" do
        CEC.Remote.send_stop(:tv, :up)
        expect(GenServer) |> to(accepted :call, [CEC.Process, {:send_code, "F0:45"}])
      end

      context "device doesn't exist" do
        it "returns an error" do
          expect(CEC.Remote.send_stop(:foo, :up)) |> to(eq {:error, :not_a_device})
        end
      end

      context "key doesn't exist" do
        it "returns an error" do
          expect(CEC.Remote.send_stop(:tv, :foo)) |> to(eq {:error, :not_a_key})
        end
      end
    end
  end
end
