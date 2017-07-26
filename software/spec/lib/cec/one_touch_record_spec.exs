defmodule CEC.OneTouchRecordSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "record_off" do
    it "receives the correct code" do
      CEC.OneTouchRecord.record_off(:tv, :recording_1)
      assert_receive("01:0B")
    end
  end

  describe "record_on" do
    it "receives the correct code"
  end

  describe "record_status" do
    describe "recording currently selected source" do
      it "receives the correct code" do
        CEC.OneTouchRecord.record_status(:tv, :recording_1, :currently_selected)
        assert_receive("01:0A:01")
      end
    end

    describe "recording digital source" do
      it "receives the correct code" do
        CEC.OneTouchRecord.record_status(:tv, :recording_1, :digital)
        assert_receive("01:0A:02")
      end
    end

    describe "recording analogue source" do
      it "receives the correct code" do
        CEC.OneTouchRecord.record_status(:tv, :recording_1, :analogue)
        assert_receive("01:0A:03")
      end
    end

    describe "recording analogue source" do
      it "receives the correct code" do
        CEC.OneTouchRecord.record_status(:tv, :recording_1, :external)
        assert_receive("01:0A:04")
      end
    end

    describe "errors" do

    end
  end

  describe "record_tv_screen" do
    it "receives the correct code" do
      CEC.OneTouchRecord.record_tv_screen(:tv, :recording_1)
      assert_receive("01:0F")
    end
  end
end
