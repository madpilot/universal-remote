defmodule CEC.Mapping.DeckStatusRequest do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      on: 0x01,
      off: 0x02,
      once: 0x03
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
