defmodule CECSpec do
  use ESpec

  describe "command with no arguments" do
    it "receives the correct code" do
      expect CEC.code(:recording_1, :tv, 0xFF) |> to(eq "10:FF")
    end
  end

  describe "command with routing address" do
    it "receives the correct code" do
      expect(CEC.code(:recording_2, :tv, 0x82, "3.1.0.0")) |> to(eq("20:82:31:00"))
    end
  end

  describe "command with a string" do
    it "receives the correct code" do
      expect(CEC.code(:tuner_1, :tv, 0x47, "Test")) |> to(eq("30:47:54:65:73:74"))
    end
  end
end
