defmodule CEC.SystemStandbySpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "text_view_on" do
    it "receives the correct code" do
      CEC.SystemStandby.standby(:tuner_2, :recording_2)
      assert_receive("62:36")
    end

    it "defaults the destination to broadcast" do
      CEC.SystemStandby.standby(:tuner_2)
      assert_receive("6F:36")
    end
  end
end
