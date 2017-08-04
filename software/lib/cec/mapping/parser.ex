defmodule CEC.Mapping.Parser do
  alias CEC.Mapping.{Source, Destination, OpCodes}
  use Bitwise, only_operators: true

  def map_devices(devices) do
    integer = devices |> Integer.parse(16) |> elem(0)

    %{
      source: Source.from_code((integer &&& 0xf0) >>> 4),
      destination: Destination.from_code(integer &&& 0xf)
    }
  end

  def map_opcode(opcode)do
    OpCodes.from_code(opcode |> Integer.parse(16) |> elem(0))
  end

  def map_elements(%{devices: devices, opcode: opcode, arguments: arguments}) do
    %{devices: devices, opcode: opcode}
    |> map_elements()
    |> Map.merge(%{arguments: arguments})
  end

  def map_elements(%{devices: devices, opcode: opcode}) do
    %{devices: devices}
    |> map_elements()
    |> Map.merge(%{opcode: map_opcode(opcode)})
  end

  def map_elements(%{devices: devices}) do
    map_devices(devices)
  end

  def process(codes) do
    case codes do
      [devices | [opcode | arguments]] -> map_elements(%{devices: devices, opcode: opcode, arguments: arguments})
      [devices | [opcode]] -> map_elements(%{devices: devices, opcode: opcode})
      [devices] -> map_elements(%{devices: devices})
    end
  end

  def from_code(code) do
    code
    |> String.trim
    |> String.split(":")
    |> process
  end
end
