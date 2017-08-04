defmodule CEC.Mapping.Destination do
  alias CEC.Mapping.Mapper

  def devices do
    [
      tv: 0x0,
      recording_1: 0x1,
      recording_2: 0x2,
      tuner_1: 0x3,
      playback_1: 0x4,
      audio_system: 0x5,
      tuner_2: 0x6,
      tuner_3: 0x7,
      playback_2: 0x8,
      playback_3: 0x9,
      tuner_4: 0xA,
      playback_4: 0xB,
      reserved_c: 0xC,
      reserved_d: 0xD,
      reserved_e: 0xE,
      broadcast: 0xF
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
