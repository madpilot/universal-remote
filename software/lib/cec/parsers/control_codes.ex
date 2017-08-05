defmodule CEC.Parsers.ControlCodes do
  alias CEC.Mapping.{ControlCodes}

  def user_pressed(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> ControlCodes.from_code
    end
  end
end
