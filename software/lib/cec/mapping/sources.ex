defmodule CEC.Mapping.Sources do
  alias CEC.Mapping.Mapper

  def sources do
    [
      currently_selected: 0x01,
      digital: 0x02,
      analogue: 0x03,
      external: 0x04
    ]
  end

  def to_code(source) do
    sources()
    |> Mapper.to_code(source)
  end

  def from_code(code) do
    sources()
    |> Mapper.from_code(code)
  end
end
