defmodule CEC.Mapping do
  def devices do
    [
      tv: "00",
      recording_1: "01",
      recording_2: "02",
      tuner_1: "03",
      playback_1: "04",
      audio_system: "05",
      tuner_2: "06",
      tuner_3: "07",
      playback_2: "08",
      playback_3: "09",
      tuner_4: "0A",
      playback_4: "0B",
      reserved_c: "0C",
      reserved_d: "0D",
      reserved_e: "0E",
      broadcast: "0F",
      undefined: "0F"
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
