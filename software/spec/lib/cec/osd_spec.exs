defmodule CEC.OSDSpec do
  use ESpec

  alias CEC.OSD

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "set_osd_string" do
    it "receives the correct code" do
      OSD.set_osd_string(:recording_1, :tv, :display_until_cleared, "Test message")
      assert_receive("10:64:40:54:65:73:74:20:6D:65:73:73:61:67:65")
    end
  end
end
