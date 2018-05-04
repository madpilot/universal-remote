defmodule CEC.Mapping.PowerStatus do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      on: 0x00,
      standby: 0x01,
      transition_standby_to_on: 0x02,
      transition_on_to_standby: 0x03
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
