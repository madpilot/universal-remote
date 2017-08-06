defmodule CEC.Mapping.VersionsSpec do
  use ESpec
  alias CEC.Mapping.Versions


  describe("to_code") do
    it "maps 1.1" do
      expect(Versions.to_code("1.1")) |> to(eq(0x0))
    end

    it "maps 1.2" do
      expect(Versions.to_code("1.2")) |> to(eq(0x1))
    end

    it "maps 1.2a" do
      expect(Versions.to_code("1.2a")) |> to(eq(0x2))
    end

    it "maps 1.3" do
      expect(Versions.to_code("1.3")) |> to(eq(0x3))
    end

    it "maps 1.3a" do
      expect(Versions.to_code("1.3a")) |> to(eq(0x4))
    end
  end

  describe("from_code") do
    it "maps 0x0" do
      expect(Versions.from_code(0x0)) |> to(eq("1.1"))
    end

    it "maps 0x1" do
      expect(Versions.from_code(0x1)) |> to(eq("1.2"))
    end

    it "maps 0x2" do
      expect(Versions.from_code(0x2)) |> to(eq("1.2a"))
    end

    it "maps 0x3" do
      expect(Versions.from_code(0x3)) |> to(eq("1.3"))
    end

    it "maps 0x4" do
      expect(Versions.from_code(0x4)) |> to(eq("1.3a"))
    end
  end
end
