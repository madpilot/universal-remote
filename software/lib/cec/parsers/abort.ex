defmodule CEC.Parsers.Abort do
  alias CEC.Mapping.{OpCodes, AbortReasons}

  def feature_abort(arguments) do
    case arguments do
      [opcode, reason] -> %{op_code: OpCodes.from_code(opcode |> Integer.parse(16) |> elem(0)), reason: AbortReasons.from_code(reason |> Integer.parse(16) |> elem(0))}
    end
  end
end
