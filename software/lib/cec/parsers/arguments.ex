defmodule CEC.Parsers.Arguments do
  alias CEC.Mapping.Vendor

  def to_ascii(arguments) do
    arguments
    |> Enum.map(fn(int) -> int |> Integer.parse(16) |> elem(0) end)
    |> to_string
  end

  def to_address(arguments) do
    arguments
    |> Enum.join("")
    |> String.split("", trim: true)
    |> Enum.join(".")
  end

  def to_integer(arguments) do
    arguments
    |> Enum.join("")
    |> Integer.parse(16)
    |> elem(0)
  end

  def to_vendor(arguments) do
    to_integer(arguments)
    |> Vendor.from_code
  end
end
