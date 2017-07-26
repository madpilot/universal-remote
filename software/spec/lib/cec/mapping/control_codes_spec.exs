defmodule CEC.Mapping.ControlCodesSpec do
  use ESpec
  alias CEC.Mapping.ControlCodes

  describe "device code mappings" do
    it "maps select" do
      expect(ControlCodes.controls[:select]) |> to(eq(0x00))
    end

    it "maps up" do
      expect(ControlCodes.controls[:up]) |> to(eq(0x01))
    end

    it "maps down" do
      expect(ControlCodes.controls[:down]) |> to(eq(0x02))
    end

    it "maps left" do
      expect(ControlCodes.controls[:left]) |> to(eq(0x03))
    end

    it "maps right" do
      expect(ControlCodes.controls[:right]) |> to(eq(0x04))
    end

    it "maps right_up" do
      expect(ControlCodes.controls[:right_up]) |> to(eq(0x5))
    end

    it "maps right_down" do
      expect(ControlCodes.controls[:right_down]) |> to(eq(0x6))
    end

    it "maps left_up" do
      expect(ControlCodes.controls[:left_up]) |> to(eq(0x7))
    end

    it "maps left_down" do
      expect(ControlCodes.controls[:left_down]) |> to(eq(0x8))
    end

    it "maps root_menu" do
      expect(ControlCodes.controls[:root_menu]) |> to(eq(0x9))
    end

    it "maps setup_menu" do
      expect(ControlCodes.controls[:setup_menu]) |> to(eq(0xA))
    end

    it "maps contents_menu" do
      expect(ControlCodes.controls[:contents_menu]) |> to(eq(0xB))
    end

    it "maps favourite_menu" do
      expect(ControlCodes.controls[:favourite_menu]) |> to(eq(0xC))
    end

		it "maps exit" do
      expect(ControlCodes.controls[:exit]) |> to(eq(0xD))
    end

    it "maps num_0" do
      expect(ControlCodes.controls[:num_0]) |> to(eq(0x20))
    end

    it "maps num_1" do
      expect(ControlCodes.controls[:num_1]) |> to(eq(0x21))
    end

    it "maps num_2" do
      expect(ControlCodes.controls[:num_2]) |> to(eq(0x22))
    end

    it "maps num_3" do
      expect(ControlCodes.controls[:num_3]) |> to(eq(0x23))
    end

    it "maps num_4" do
      expect(ControlCodes.controls[:num_4]) |> to(eq(0x24))
    end

    it "maps num_5" do
      expect(ControlCodes.controls[:num_5]) |> to(eq(0x25))
    end

    it "maps num_6" do
      expect(ControlCodes.controls[:num_6]) |> to(eq(0x26))
    end

    it "maps num_7" do
      expect(ControlCodes.controls[:num_7]) |> to(eq(0x27))
    end

    it "maps num_8" do
      expect(ControlCodes.controls[:num_8]) |> to(eq(0x28))
    end

    it "maps num_9" do
      expect(ControlCodes.controls[:num_9]) |> to(eq(0x29))
    end

		it "maps dot" do
      expect(ControlCodes.controls[:dot]) |> to(eq(0x2A))
    end

    it "maps enter" do
      expect(ControlCodes.controls[:enter]) |> to(eq(0x2B))
    end

    it "maps clear" do
      expect(ControlCodes.controls[:clear]) |> to(eq(0x2C))
    end

    it "maps next_favourite" do
      expect(ControlCodes.controls[:next_favourite]) |> to(eq(0x2F))
    end

    it "maps channel_up" do
      expect(ControlCodes.controls[:channel_up]) |> to(eq(0x30))
    end

    it "maps channel_down" do
      expect(ControlCodes.controls[:channel_down]) |> to(eq(0x31))
    end

    it "maps previous_channel" do
      expect(ControlCodes.controls[:previous_channel]) |> to(eq(0x32))
    end

    it "maps sound_select" do
      expect(ControlCodes.controls[:sound_select]) |> to(eq(0x33))
    end

    it "maps input_select" do
      expect(ControlCodes.controls[:input_select]) |> to(eq(0x34))
    end

    it "maps display_information" do
      expect(ControlCodes.controls[:display_information]) |> to(eq(0x35))
    end

    it "maps help" do
      expect(ControlCodes.controls[:help]) |> to(eq(0x36))
    end

		it "maps page_up" do
      expect(ControlCodes.controls[:page_up]) |> to(eq(0x37))
    end

    it "maps page_down" do
      expect(ControlCodes.controls[:page_down]) |> to(eq(0x38))
    end

    it "maps power" do
      expect(ControlCodes.controls[:power]) |> to(eq(0x40))
    end

    it "maps volume_up" do
      expect(ControlCodes.controls[:volume_up]) |> to(eq(0x41))
    end

    it "maps volume_down" do
      expect(ControlCodes.controls[:volume_down]) |> to(eq(0x42))
    end

    it "maps mute" do
      expect(ControlCodes.controls[:mute]) |> to(eq(0x43))
    end

    it "maps play" do
      expect(ControlCodes.controls[:play]) |> to(eq(0x44))
    end

    it "maps stop" do
      expect(ControlCodes.controls[:stop]) |> to(eq(0x45))
    end

    it "maps pause" do
      expect(ControlCodes.controls[:pause]) |> to(eq(0x46))
    end

    it "maps record" do
      expect(ControlCodes.controls[:record]) |> to(eq(0x47))
    end

    it "maps rewind" do
      expect(ControlCodes.controls[:rewind]) |> to(eq(0x48))
    end

		it "maps fast_forward" do
      expect(ControlCodes.controls[:fast_forward]) |> to(eq(0x49))
    end

    it "maps eject" do
      expect(ControlCodes.controls[:eject]) |> to(eq(0x4A))
    end

    it "maps forward" do
      expect(ControlCodes.controls[:forward]) |> to(eq(0x4B))
    end

    it "maps backward" do
      expect(ControlCodes.controls[:backward]) |> to(eq(0x4C))
    end

    it "maps stop_record" do
      expect(ControlCodes.controls[:stop_record]) |> to(eq(0x4D))
    end

    it "maps pause_record" do
      expect(ControlCodes.controls[:pause_record]) |> to(eq(0x4E))
    end

    it "maps angle" do
      expect(ControlCodes.controls[:angle]) |> to(eq(0x50))
    end

    it "maps sub_picture" do
      expect(ControlCodes.controls[:sub_picture]) |> to(eq(0x51))
    end

    it "maps video_on_demand" do
      expect(ControlCodes.controls[:video_on_demand]) |> to(eq(0x52))
    end

    it "maps electronic_program_guide" do
      expect(ControlCodes.controls[:electronic_program_guide]) |> to(eq(0x53))
    end

    it "maps timer_programming" do
      expect(ControlCodes.controls[:timer_programming]) |> to(eq(0x54))
    end

		it "maps initial_configuration" do
      expect(ControlCodes.controls[:initial_configuration]) |> to(eq(0x55))
    end

    it "maps play_function" do
      expect(ControlCodes.controls[:play_function]) |> to(eq(0x60))
    end

    it "maps play_pause_function" do
      expect(ControlCodes.controls[:play_pause_function]) |> to(eq(0x61))
    end

    it "maps record_function" do
      expect(ControlCodes.controls[:record_function]) |> to(eq(0x62))
    end

    it "maps pause_record_function" do
      expect(ControlCodes.controls[:pause_record_function]) |> to(eq(0x63))
    end

    it "maps stop_function" do
      expect(ControlCodes.controls[:stop_function]) |> to(eq(0x64))
    end

    it "maps mute_function" do
      expect(ControlCodes.controls[:mute_function]) |> to(eq(0x65))
    end

    it "maps restore_volume_function" do
      expect(ControlCodes.controls[:restore_volume_function]) |> to(eq(0x66))
    end

    it "maps tune_function" do
      expect(ControlCodes.controls[:tune_function]) |> to(eq(0x67))
    end

    it "maps select_media_function" do
      expect(ControlCodes.controls[:select_media_function]) |> to(eq(0x68))
    end

    it "maps select_av_input_function" do
      expect(ControlCodes.controls[:select_av_input_function]) |> to(eq(0x69))
    end

		it "maps select_audio_function" do
      expect(ControlCodes.controls[:select_audio_function]) |> to(eq(0x6A))
    end

    it "maps power_toggle_function" do
      expect(ControlCodes.controls[:power_toggle_function]) |> to(eq(0x6B))
    end

    it "maps power_off_function" do
      expect(ControlCodes.controls[:power_off_function]) |> to(eq(0x6C))
    end

    it "maps power_on_function" do
      expect(ControlCodes.controls[:power_on_function]) |> to(eq(0x6D))
    end

    it "maps blue" do
      expect(ControlCodes.controls[:blue]) |> to(eq(0x71))
    end

    it "maps red" do
      expect(ControlCodes.controls[:red]) |> to(eq(0x72))
    end

    it "maps green" do
      expect(ControlCodes.controls[:green]) |> to(eq(0x73))
    end

    it "maps yellow" do
      expect(ControlCodes.controls[:yellow]) |> to(eq(0x74))
    end

    it "maps f1" do
      expect(ControlCodes.controls[:f1]) |> to(eq(0x71))
    end

    it "maps f2" do
      expect(ControlCodes.controls[:f2]) |> to(eq(0x72))
    end

    it "maps f3" do
      expect(ControlCodes.controls[:f3]) |> to(eq(0x73))
    end

		it "maps f4" do
      expect(ControlCodes.controls[:f4]) |> to(eq(0x74))
    end

    it "maps f5" do
      expect(ControlCodes.controls[:f5]) |> to(eq(0x75))
    end

    it "maps data" do
      expect(ControlCodes.controls[:data]) |> to(eq(0x76))
    end
  end

  describe("to_code") do
    it "maps the control name to the relevant code" do
      expect(ControlCodes.to_code(:select)) |> to(eq(0x00))
    end
  end

  describe("from_code") do
    it "maps the code to the control name" do
      expect(ControlCodes.from_code(0x00)) |> to(eq(:select))
    end

    it "maps :reserved codes" do
      test_func = fn(code) ->
        expect(ControlCodes.from_code(code)) |> to(eq(:reserved))
      end

      0x0E..0x1F |> Enum.each(test_func)
      0x2D..0x2E |> Enum.each(test_func)
      0x39..0x3F |> Enum.each(test_func)
      0x56..0x5F |> Enum.each(test_func)
      0x6E..0x70 |> Enum.each(test_func)
      0x77..0xFF |> Enum.each(test_func)
    end

    it "maps to nil of the code doesn't exist" do
      expect(ControlCodes.from_code(0x100)) |> to(eq(nil))
    end
  end
end
