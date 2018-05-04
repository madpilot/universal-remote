defmodule CEC.Mapping.AudioRateControlSpec do
  use ESpec
  alias CEC.Mapping.AudioRateControl

  describe "mappings" do
    it "maps off" do
      expect(AudioRateControl.rates[:off]) |> to(eq(0x0))
    end

    it "maps wrc_standard" do
      expect(AudioRateControl.rates[:wrc_standard]) |> to(eq(0x1))
    end

    it "maps wrc_fast" do
      expect(AudioRateControl.rates[:wrc_fast]) |> to(eq(0x2))
    end

    it "maps wrc_slow" do
      expect(AudioRateControl.rates[:wrc_slow]) |> to(eq(0x3))
    end

    it "maps nrc_standard" do
      expect(AudioRateControl.rates[:nrc_standard]) |> to(eq(0x4))
    end

    it "maps nrc_fast" do
      expect(AudioRateControl.rates[:nrc_fast]) |> to(eq(0x5))
    end

    it "maps nrc_slow" do
      expect(AudioRateControl.rates[:nrc_slow]) |> to(eq(0x6))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(AudioRateControl.to_code(:wrc_standard)) |> to(eq(0x1))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(AudioRateControl.from_code(0x2)) |> to(eq(:wrc_fast))
    end
  end
end
