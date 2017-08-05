defmodule CEC.AbortSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "feature_abort" do
    it "receives the correct code" do
      CEC.Abort.feature_abort(:audio_system, :playback_1, :play, :not_in_correct_mode_to_respond)
      assert_receive("54:00:41:01")
    end
  end

  describe "abort" do
    it "receives the correct code" do
      CEC.Abort.abort(:audio_system, :playback_1)
      assert_receive("54:FF")
    end
  end
end
