defmodule CEC.Mapping.Devices do
  def devices do
    [
      tv: 0x00,
      recording_1: 0x01,
      recording_2: 0x02,
      tuner_1: 0x03,
      playback_1: 0x04,
      audio_system: 0x05,
      tuner_2: 0x06,
      tuner_3: 0x07,
      playback_2: 0x08,
      playback_3: 0x09,
      tuner_4: 0x0A,
      playback_4: 0x0B,
      reserved_c: 0x0C,
      reserved_d: 0x0D,
      reserved_e: 0x0E,
      broadcast: 0x0F,
      undefined: 0x0F
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
