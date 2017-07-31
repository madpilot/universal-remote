defmodule CEC.Mapping.Display do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      display_for_default_time: 0x00,
      display_until_cleared: 0x40,
      clear_previous_message: 0x80,
      reserved: 0xc0
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
