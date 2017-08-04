defmodule CEC.Mapping.Parser do
  alias CEC.Mapping.{Source, Destination, OpCodes, Vendor}
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

  def arguments_to_string(arguments) do
    arguments
    |> Enum.map(fn(int) -> int |> Integer.parse(16) |> elem(0) end)
    |> to_string
  end

  def arguments_to_address(arguments) do
    arguments
    |> Enum.join(".")
  end

  def arguments_to_integer(arguments) do
    arguments
    |> Enum.join("")
    |> Integer.parse(16)
    |> elem(0)
  end

  def arguments_to_vendor(arguments) do
    arguments_to_integer(arguments)
    |> Vendor.from_code
  end

  def map_arguments(opcode, arguments) do
    case opcode |> map_opcode do
      :set_osd_name -> %{value: arguments_to_string(arguments)}
      :device_vendor_id -> %{vendor: arguments_to_vendor(arguments)}

      _ -> %{arguments: arguments}
    end
  end

  def map_elements(%{devices: devices, opcode: opcode, arguments: arguments}) do
    %{devices: devices, opcode: opcode}
    |> map_elements()
    |> Map.merge(map_arguments(opcode, arguments))
  end

  def map_elements(%{devices: devices, opcode: opcode}) do
    %{devices: devices}
    |> map_elements()
    |> Map.merge(%{command: map_opcode(opcode)})
  end

  def map_elements(%{devices: devices}) do
    map_devices(devices)
  end

  def process(codes) do
    case codes do
      [devices | []] -> map_elements(%{devices: devices}) |> Map.merge(%{command: :polling})
      [devices | [opcode | []]] -> map_elements(%{devices: devices, opcode: opcode})
      [devices | [opcode | arguments]] -> map_elements(%{devices: devices, opcode: opcode, arguments: arguments})
    end
  end

  def from_code(code) do
    code
    |> Apex.ap
    |> String.trim
    |> String.split(":")
    |> process
  end
end
