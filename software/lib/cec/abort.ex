defmodule CEC.Abort do
  alias CEC.Mapping.{OpCodes, AbortReasons}

  def feature_abort(source, destination, opcode, reason) do
    CEC.send(source, destination, OpCodes.to_code(:feature_abort), [OpCodes.to_code(opcode), AbortReasons.to_code(reason)])
  end

  def abort(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:abort))
  end
end
