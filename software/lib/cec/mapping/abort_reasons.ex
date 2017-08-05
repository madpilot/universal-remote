defmodule CEC.Mapping.AbortReasons do
  alias CEC.Mapping.Mapper

  def reasons do
    [
      unrecognised_opcode: 0x00,
      not_in_correct_mode_to_respond: 0x01,
      cannot_provide_source: 0x02,
      invalid_operand: 0x03,
      refused: 0x04
    ]
  end

  def to_code(reason) do
    reasons()
    |> Mapper.to_code(reason)
  end

  def from_code(code) do
    reasons()
    |> Mapper.from_code(code)
  end
end
