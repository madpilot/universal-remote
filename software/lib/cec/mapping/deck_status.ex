defmodule CEC.Mapping.DeckStatus do
  alias CEC.Mapping.Mapper

  def statuses do
    [
      play: 0x11,
      record: 0x12,
      play_reverse: 0x13,
      still: 0x14,
      slow: 0x15,
      slow_reverse: 0x16,
      fast_forward: 0x17,
      fast_reverse: 0x18,
      no_media: 0x19,
      stop: 0x1a,
      skip_forward: 0x1b,
      skip_reverse: 0x1c,
      search_forward: 0x1d,
      search_reverse: 0x1e,
      other: 0x1f
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
