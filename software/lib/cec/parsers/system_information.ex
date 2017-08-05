defmodule CEC.Parsers.SystemInformation do
  alias CEC.Parsers.{Arguments}
  alias CEC.Mapping.{Devices}

  def report_physical_address(arguments) do
    case arguments do
      [msb, lsb, type] -> %{address: Arguments.to_address([msb, lsb]), type: type |> Integer.parse(16) |> elem(0) |> Devices.from_code}
    end
  end

  def routing_change(arguments) do
    case arguments do
      [orig_msb, orig_lsb, new_msb, new_lsb] -> %{original_address: Arguments.to_address([orig_msb, orig_lsb]), new_address: Arguments.to_address([new_msb, new_lsb])}
    end
  end
end
