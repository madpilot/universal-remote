defmodule CEC.Parsers.SystemAudioControl do
  defp _give_audio_status(amount) do
    if amount > 127 do
      %{muted: true, volume: amount - 127}
    else
      %{muted: false, volume: amount}
    end
  end

  def give_audio_status(arguments) do
    case arguments do
      [code] -> _give_audio_status(code |> Integer.parse(16) |> elem(0))
    end
  end
end
