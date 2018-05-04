defmodule CEC.Mapping.AudioStatus do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      off: 0x00,
      on: 0x01
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
