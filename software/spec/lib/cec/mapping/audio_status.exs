defmodule CEC.Mapping.AudioStatusSpec do
  use ESpec
  alias CEC.Mapping.AudioStatus

  describe "source code mappings" do
    it "maps off" do
      expect(AudioStatus.request_types[:off]) |> to(eq(0x0))
    end

    it "maps on" do
      expect(AudioStatus.request_types[:on]) |> to(eq(0x1))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(MenuRequest.to_code(:off)) |> to(eq(0x0))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(MenuRequest.from_code(0x1)) |> to(eq(:on))
    end
  end
end
