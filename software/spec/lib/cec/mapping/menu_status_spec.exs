defmodule CEC.Mapping.MenuStatusSpec do
  use ESpec
  alias CEC.Mapping.MenuStatus

  describe "source code mappings" do
    it "maps activate" do
      expect(MenuStatus.statuses[:activated]) |> to(eq(0x0))
    end

    it "maps deactivate" do
      expect(MenuStatus.statuses[:deactivated]) |> to(eq(0x1))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(MenuStatus.to_code(:deactivated)) |> to(eq(0x1))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(MenuStatus.from_code(0x1)) |> to(eq(:deactivated))
    end
  end
end
