defmodule CEC.Mapping.DeckPlaySpec do
  use ESpec
  alias CEC.Mapping.DeckPlay

  describe "source code mappings" do
    it "maps fast_forward_min_speed" do
      expect(DeckPlay.statuses[:fast_forward_min_speed]) |> to(eq(0x05))
    end

    it "maps fast_forward_medium_speed" do
      expect(DeckPlay.statuses[:fast_forward_medium_speed]) |> to(eq(0x06))
    end

    it "maps fast_forward_max_speed" do
      expect(DeckPlay.statuses[:fast_forward_max_speed]) |> to(eq(0x07))
    end

    it "maps fast_reverse_min_speed" do
      expect(DeckPlay.statuses[:fast_reverse_min_speed]) |> to(eq(0x09))
    end

    it "maps fast_reverse_medium_speed" do
      expect(DeckPlay.statuses[:fast_reverse_medium_speed]) |> to(eq(0x0a))
    end

    it "maps fast_reverse_max_speed" do
      expect(DeckPlay.statuses[:fast_reverse_max_speed]) |> to(eq(0x0b))
    end

    it "maps slow_forward_min_speed" do
      expect(DeckPlay.statuses[:slow_forward_min_speed]) |> to(eq(0x15))
    end

    it "maps slow_forward_medium_speed" do
      expect(DeckPlay.statuses[:slow_forward_medium_speed]) |> to(eq(0x16))
    end

    it "maps slow_forward_max_speed" do
      expect(DeckPlay.statuses[:slow_forward_max_speed]) |> to(eq(0x17))
    end

    it "maps slow_reverse_min_speed" do
      expect(DeckPlay.statuses[:slow_reverse_min_speed]) |> to(eq(0x19))
    end

    it "maps slow_reverse_medium_speed" do
      expect(DeckPlay.statuses[:slow_reverse_medium_speed]) |> to(eq(0x1a))
    end

    it "maps slow_reverse_max_speed" do
      expect(DeckPlay.statuses[:slow_reverse_max_speed]) |> to(eq(0x1b))
    end

    it "maps play_reverse" do
      expect(DeckPlay.statuses[:play_reverse]) |> to(eq(0x20))
    end

    it "maps play_forward" do
      expect(DeckPlay.statuses[:play_forward]) |> to(eq(0x24))
    end

    it "maps play_still" do
      expect(DeckPlay.statuses[:play_still]) |> to(eq(0x25))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(DeckPlay.to_code(:slow_forward_min_speed)) |> to(eq(0x15))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(DeckPlay.from_code(0x1b)) |> to(eq(:slow_reverse_max_speed))
    end
  end
end
