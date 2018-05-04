defmodule CEC.Mapping.AbortReasonsSpec do
  use ESpec
  alias CEC.Mapping.AbortReasons

  describe "mappings" do
    it "maps unrecognised_opcode" do
      expect(AbortReasons.reasons[:unrecognised_opcode]) |> to(eq(0x0))
    end

    it "maps not_in_correct_mode_to_respond" do
      expect(AbortReasons.reasons[:not_in_correct_mode_to_respond]) |> to(eq(0x1))
    end

    it "maps cannot_provide_source" do
      expect(AbortReasons.reasons[:cannot_provide_source]) |> to(eq(0x2))
    end

    it "maps invalid_operand" do
      expect(AbortReasons.reasons[:invalid_operand]) |> to(eq(0x3))
    end

    it "maps refused" do
      expect(AbortReasons.reasons[:refused]) |> to(eq(0x4))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(AbortReasons.to_code(:not_in_correct_mode_to_respond)) |> to(eq(0x1))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(AbortReasons.from_code(0x2)) |> to(eq(:cannot_provide_source))
    end
  end
end
