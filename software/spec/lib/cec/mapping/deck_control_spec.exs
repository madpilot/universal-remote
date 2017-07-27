defmodule CEC.Mapping.DeckControlSpec do
  use ESpec
  alias CEC.Mapping.DeckControl

  describe "source code mappings" do
    it "maps skip_forward" do
      expect(DeckControl.statuses[:skip_forward]) |> to(eq(0x1))
    end

    it "maps skip_reverse" do
      expect(DeckControl.statuses[:skip_reverse]) |> to(eq(0x2))
    end

    it "maps stop" do
      expect(DeckControl.statuses[:stop]) |> to(eq(0x3))
    end

    it "maps skip_reverse" do
      expect(DeckControl.statuses[:eject]) |> to(eq(0x4))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(DeckControl.to_code(:stop)) |> to(eq(0x3))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(DeckControl.from_code(0x2)) |> to(eq(:skip_reverse))
    end
  end
end
