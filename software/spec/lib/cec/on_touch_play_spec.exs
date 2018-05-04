defmodule CEC.OneTouchPlaySpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "active_source" do
    it "receives the correct code" do
      CEC.OneTouchPlay.active_source(:recording_1, :tv, "4.3.0.1")
      assert_receive("10:82:43:01")
    end
  end

  describe "image_view_on" do
    it "receives the correct code" do
      CEC.OneTouchPlay.image_view_on(:recording_1, :recording_2)
      assert_receive("12:04")
    end

    it "defaults the destination to tv" do
      CEC.OneTouchPlay.image_view_on(:recording_1)
      assert_receive("10:04")
    end
  end

  describe "text_view_on" do
    it "receives the correct code" do
      CEC.OneTouchPlay.text_view_on(:recording_1, :recording_2)
      assert_receive("12:0D")
    end

    it "defaults the destination to tv" do
      CEC.OneTouchPlay.text_view_on(:recording_1)
      assert_receive("10:0D")
    end
  end
end
