defmodule CEC.Mapping.Devices do
  alias CEC.Mapping.Mapper

  def devices do
    [
      recording: 0x1,
      reserved: 0x2,
      tuner: 0x3,
      playback: 0x4
    ]
  end

  def to_code(control) do
    devices()
    |> Mapper.to_code(control)
  end

  def from_code(code) do
    devices()
    |> Mapper.from_code(code)
  end
end
