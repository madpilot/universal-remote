defmodule CEC.Parsers.DeviceMenuControl do
  alias CEC.Mapping.{MenuStatus, MenuRequest}

  def menu_status(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> MenuStatus.from_code
    end
  end

  def menu_request(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> MenuRequest.from_code
    end
  end
end
