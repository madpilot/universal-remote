defmodule CEC.Parsers.AudioRateControl do
  alias CEC.Mapping.{AudioRateControl}

  def set_audio_rate(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> AudioRateControl.from_code
    end
  end
end
