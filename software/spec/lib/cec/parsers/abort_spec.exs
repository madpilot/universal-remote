defmodule CEC.Parsers.AbortSpec do
  use ESpec

  describe "feature_abort" do
    it "parses the arguments" do
      expect(CEC.Parsers.Abort.feature_abort([0x41, 0x01])) |> to(eq %{opcode: :play, reason: :not_in_correct_mode_to_respond})
    end
  end
end
