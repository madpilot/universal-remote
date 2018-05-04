defmodule CEC.Mapping.MenuStatus do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      activated: 0x00,
      deactivated: 0x01
    ]
  end

  def to_code(status) do
    statuses()
    |> Mapper.to_code(status)
  end

  def from_code(status) do
    statuses()
    |> Mapper.from_code(status)
  end
end
