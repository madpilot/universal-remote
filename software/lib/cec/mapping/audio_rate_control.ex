defmodule CEC.Mapping.AudioRateControl do
  alias CEC.Mapping.Mapper

  def rates do
    [
      off: 0x00,
      wrc_standard: 0x01,
      wrc_fast: 0x02,
      wrc_slow: 0x03,
      nrc_standard: 0x04,
      nrc_fast: 0x05,
      nrc_slow: 0x06
    ]
  end

  def to_code(rate) do
    rates()
    |> Mapper.to_code(rate)
  end

  def from_code(code) do
    rates()
    |> Mapper.from_code(code)
  end
end
