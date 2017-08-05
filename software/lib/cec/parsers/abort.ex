defmodule CEC.Parsers.Abort do
  alias CEC.Mapping.{OpCodes, AbortReasons}

  def feature_abort(arguments) do
    case arguments do
      [opcode, reason] -> %{opcode: OpCodes.from_code(opcode), reason: AbortReasons.from_code(reason)}
    end
  end
end
