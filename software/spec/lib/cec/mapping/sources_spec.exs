defmodule CEC.Mapping.SourcesSpec do
  use ESpec
  alias CEC.Mapping.Sources

  describe "source code mappings" do
    it "maps currently_selected" do
      expect(Sources.sources[:currently_selected]) |> to(eq(0x1))
    end

    it "maps digital" do
      expect(Sources.sources[:digital]) |> to(eq(0x2))
    end

    it "maps analogue" do
      expect(Sources.sources[:analogue]) |> to(eq(0x3))
    end

    it "maps external" do
      expect(Sources.sources[:external]) |> to(eq(0x4))
    end
  end

  describe("source_to_code") do
    it "maps the source name to the relevant code" do
      expect(Sources.source_to_code(:digital)) |> to(eq(0x2))
    end
  end

  describe("code_to_source") do
    it "maps the code to the source name" do
      expect(Sources.code_to_source(0x2)) |> to(eq(:digital))
    end

    it "maps to nil of the source doesn't exist" do
      expect(Sources.code_to_source(0x100)) |> to(eq(nil))
    end
  end
end
