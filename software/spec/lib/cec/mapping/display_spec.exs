defmodule CEC.Mapping.DisplaySpec do
  use ESpec
  alias CEC.Mapping.Display

  describe "source code mappings" do
    it "maps display_for_default_time" do
      expect(Display.statuses[:display_for_default_time]) |> to(eq(0x0))
    end

    it "maps display_until_cleared" do
      expect(Display.statuses[:display_until_cleared]) |> to(eq(0x40))
    end

    it "maps clear_previous_message" do
      expect(Display.statuses[:clear_previous_message]) |> to(eq(0x80))
    end

    it "maps reserved" do
      expect(Display.statuses[:reserved]) |> to(eq(0xc0))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(Display.to_code(:display_until_cleared)) |> to(eq(0x40))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(Display.from_code(0x80)) |> to(eq(:clear_previous_message))
    end
  end
end
