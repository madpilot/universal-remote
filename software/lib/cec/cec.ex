defmodule CEC do
  alias CEC.Mapping.Devices
  use Bitwise, only_operators: true

  defp prepare(code) do
    code
    |> Enum.map(fn(code) -> code
                            |> Integer.to_string(16)
                            |> String.rjust(2, ?0)
                end)
    |> Enum.join(":")
    |> Apex.ap
  end

  def send(sender, receiver, command) do
    code = prepare([ Devices.device_to_code(sender) <<< 8 + Devices.device_to_code(receiver), command ])
    CEC.Process.send_code(code)
  end
end
