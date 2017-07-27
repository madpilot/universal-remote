defmodule CEC.SystemAudioControlSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "give_audio_status" do
    it "receives the correct code" do
      CEC.SystemAudioControl.give_audio_status(:tv, :audio_system)
      assert_receive("05:71")
    end
  end

  describe "give_system_audio_mode_status" do
    it "receives the correct code" do
      CEC.SystemAudioControl.give_system_audio_mode_status(:tv, :audio_system)
      assert_receive("05:7D")
    end
  end

  describe "report_audio_state" do
    describe "muted" do
      it "receives the correct code" do
        CEC.SystemAudioControl.report_audio_state(:tv, :audio_system, true, 45)
        assert_receive("05:7A:AD")
      end
    end

    describe "not muted" do
      it "receives the correct code" do
        CEC.SystemAudioControl.report_audio_state(:tv, :audio_system, false, 45)
        assert_receive("05:7A:2D")
      end
    end
  end

  describe "set_system_audio_mode" do
    it "receives the correct code" do
      CEC.SystemAudioControl.set_system_audio_mode(:tv, :audio_system, :on)
      assert_receive("05:72:01")
    end
  end

  describe "system_audio_mode_request" do
    it "receives the correct code" do
      CEC.SystemAudioControl.system_audio_mode_request(:tv, :audio_system, "2.1.0.0")
      assert_receive("05:70:21:00")
    end
  end

  describe "system_audio_mode_status" do
    it "receives the correct code" do
      CEC.SystemAudioControl.system_audio_mode_status(:tv, :audio_system, :off)
      assert_receive("05:7E:00")
    end
  end

  describe "user_pressed" do
    it "receives the correct code" do
      CEC.SystemAudioControl.user_pressed(:unregistered, :audio_system, :power_on_function)
      assert_receive("F5:44:6D")
    end
  end

  describe "user_released" do
    it "receives the correct code" do
      CEC.SystemAudioControl.user_released(:unregistered, :audio_system)
      assert_receive("F5:45")
    end
  end
end
