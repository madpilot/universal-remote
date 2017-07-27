defmodule CEC.DeckControlSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "deck_status" do
    it "receives the correct code" do
      CEC.DeckControl.deck_status(:audio_system, :playback_1, :slow)
      assert_receive("54:1B:15")
    end
  end

  describe "give_deck_status" do
    it "receives the correct code" do
      CEC.DeckControl.give_deck_status(:audio_system, :playback_1, :off)
      assert_receive("54:1A:02")
    end
  end

  describe "deck_control" do
    it "receives the correct code" do
      CEC.DeckControl.deck_control(:audio_system, :playback_1, :stop)
      assert_receive("54:42:03")
    end
  end

  describe "play" do
    it "receives the correct code" do
      CEC.DeckControl.play(:audio_system, :playback_1, :fast_reverse_max_speed)
      assert_receive("54:41:0B")
    end
  end
end
