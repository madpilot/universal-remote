defmodule CEC.Mapping.MenuRequest do
  alias CEC.Mapping.Mapper

  def request_types do
    [
      activate: 0x00,
      deactivate: 0x01,
      query: 0x02
    ]
  end

  def to_code(type) do
    request_types()
    |> Mapper.to_code(type)
  end

  def from_code(type) do
    request_types()
    |> Mapper.from_code(type)
  end
end
