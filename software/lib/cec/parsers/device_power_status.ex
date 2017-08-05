defmodule CEC.Parsers.DevicePowerStatus do
  alias CEC.Mapping.{PowerStatus}

  def report_power_status(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> PowerStatus.from_code
    end
  end
end
