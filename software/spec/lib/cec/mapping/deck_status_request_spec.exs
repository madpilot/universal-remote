defmodule CEC.Mapping.DeckStatusRequestSpec do
  use ESpec
  alias CEC.Mapping.DeckStatusRequest

  describe "source code mappings" do
    it "maps play" do
      expect(DeckStatusRequest.statuses[:on]) |> to(eq(0x01))
    end

    it "maps record" do
      expect(DeckStatusRequest.statuses[:off]) |> to(eq(0x02))
    end

    it "maps play_reverse" do
      expect(DeckStatusRequest.statuses[:once]) |> to(eq(0x03))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(DeckStatusRequest.to_code(:on)) |> to(eq(0x01))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(DeckStatusRequest.from_code(0x03)) |> to(eq(:once))
    end
  end
end
