defmodule CEC.Mapping.DeckPlay do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      fast_forward_min_speed: 0x05,
      fast_forward_medium_speed: 0x06,
      fast_forward_max_speed: 0x07,
      fast_reverse_min_speed: 0x09,
      fast_reverse_medium_speed: 0x0a,
      fast_reverse_max_speed: 0x0b,
      slow_forward_min_speed: 0x15,
      slow_forward_medium_speed: 0x16,
      slow_forward_max_speed: 0x17,
      slow_reverse_min_speed: 0x19,
      slow_reverse_medium_speed: 0x1a,
      slow_reverse_max_speed: 0x1b,
      play_reverse: 0x20,
      play_forward: 0x24,
      play_still: 0x25
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
