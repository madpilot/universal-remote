defmodule CEC.Mapping.PowerStatusSpec do
  use ESpec
  alias CEC.Mapping.PowerStatus

  describe "source code mappings" do
    it "maps on" do
      expect(PowerStatus.statuses[:on]) |> to(eq(0x0))
    end

    it "maps standby" do
      expect(PowerStatus.statuses[:standby]) |> to(eq(0x1))
    end

    it "maps transition_standby_to_on" do
      expect(PowerStatus.statuses[:transition_standby_to_on]) |> to(eq(0x2))
    end

    it "maps transition_on_to_standby" do
      expect(PowerStatus.statuses[:transition_on_to_standby]) |> to(eq(0x3))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(PowerStatus.to_code(:standby)) |> to(eq(0x1))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(PowerStatus.from_code(0x2)) |> to(eq(:transition_standby_to_on))
    end
  end
end
