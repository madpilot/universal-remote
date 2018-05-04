defmodule CEC.Mapping.AudioStatusSpec do
  use ESpec
  alias CEC.Mapping.AudioStatus

  describe "source code mappings" do
    it "maps off" do
      expect(AudioStatus.statuses[:off]) |> to(eq(0x0))
    end

    it "maps on" do
      expect(AudioStatus.statuses[:on]) |> to(eq(0x1))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(AudioStatus.to_code(:off)) |> to(eq(0x0))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(AudioStatus.from_code(0x1)) |> to(eq(:on))
    end
  end
end
