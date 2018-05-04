defmodule CEC.Parsers.Version do
  alias CEC.Mapping.{Versions}

  def version(arguments) do
    case arguments do
      [version] -> version |> Integer.parse(16) |> elem(0) |> Versions.from_code
    end
  end
end
