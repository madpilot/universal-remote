defmodule CEC.Mapping.MenuRequestSpec do
  use ESpec
  alias CEC.Mapping.MenuRequest

  describe "source code mappings" do
    it "maps activate" do
      expect(MenuRequest.request_types[:activate]) |> to(eq(0x0))
    end

    it "maps deactivate" do
      expect(MenuRequest.request_types[:deactivate]) |> to(eq(0x1))
    end

    it "maps query" do
      expect(MenuRequest.request_types[:query]) |> to(eq(0x2))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(MenuRequest.to_code(:deactivate)) |> to(eq(0x1))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(MenuRequest.from_code(0x2)) |> to(eq(:query))
    end
  end
end
