defmodule CEC.Mapping.DeckStatusSpec do
  use ESpec
  alias CEC.Mapping.DeckStatus

  describe "source code mappings" do
    it "maps play" do
      expect(DeckStatus.statuses[:play]) |> to(eq(0x11))
    end

    it "maps record" do
      expect(DeckStatus.statuses[:record]) |> to(eq(0x12))
    end

    it "maps play_reverse" do
      expect(DeckStatus.statuses[:play_reverse]) |> to(eq(0x13))
    end

    it "maps still" do
      expect(DeckStatus.statuses[:still]) |> to(eq(0x14))
    end

    it "maps slow" do
      expect(DeckStatus.statuses[:slow]) |> to(eq(0x15))
    end

    it "maps slow_reverse" do
      expect(DeckStatus.statuses[:slow_reverse]) |> to(eq(0x16))
    end

    it "maps fast_forward" do
      expect(DeckStatus.statuses[:fast_forward]) |> to(eq(0x17))
    end

    it "maps fast_reverse" do
      expect(DeckStatus.statuses[:fast_reverse]) |> to(eq(0x18))
    end

    it "maps no_media" do
      expect(DeckStatus.statuses[:no_media]) |> to(eq(0x19))
    end

    it "maps stop" do
      expect(DeckStatus.statuses[:stop]) |> to(eq(0x1a))
    end

    it "maps skip_forward" do
      expect(DeckStatus.statuses[:skip_forward]) |> to(eq(0x1b))
    end

    it "maps skip_reverse" do
      expect(DeckStatus.statuses[:skip_reverse]) |> to(eq(0x1c))
    end

    it "maps search_forward" do
      expect(DeckStatus.statuses[:search_forward]) |> to(eq(0x1d))
    end

    it "maps search_reverse" do
      expect(DeckStatus.statuses[:search_reverse]) |> to(eq(0x1e))
    end

    it "maps other" do
      expect(DeckStatus.statuses[:other]) |> to(eq(0x1f))
    end

  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(DeckStatus.to_code(:skip_forward)) |> to(eq(0x1b))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(DeckStatus.from_code(0x15)) |> to(eq(:slow))
    end
  end
end
