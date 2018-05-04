defmodule CEC.OSDNameTransferSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "give_osd_name" do
    it "receives the correct code" do
      CEC.OSDNameTransfer.give_osd_name(:recording_1, :tv)
      assert_receive("10:46")
    end
  end

  describe "set_osd_name" do
    it "receives the correct code" do
      CEC.OSDNameTransfer.set_osd_name(:recording_1, :tv, "Test")
      assert_receive("10:47:54:65:73:74")
    end
  end
end
