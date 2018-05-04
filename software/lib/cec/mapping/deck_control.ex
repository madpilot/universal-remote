defmodule CEC.Mapping.DeckControl do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      skip_forward: 0x01,
      skip_reverse: 0x02,
      stop: 0x03,
      eject: 0x04
    ]
  end

  def to_code(status) do
    statuses()
    |> Mapper.to_code(status)
  end

  def from_code(code) do
    statuses()
    |> Mapper.from_code(code)
  end
end
