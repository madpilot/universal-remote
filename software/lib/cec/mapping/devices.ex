defmodule CEC.Mapping.Devices do
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
      broadcast: 0xF,
      undefined: 0xF
    ]
  end

  def device_to_code(device) do
    devices()[device]
  end

  def code_to_device(code) do
    result = for device <- devices(),
        fn(device, code) -> device
                            |> elem(1) == code
        end.(device, code), do: device

    case result do
      [{device, _}] -> device
            [] -> nil
    end
  end
end
