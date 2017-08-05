defmodule CEC.Mapping.Parser do
  alias CEC.Mapping.{Source, Destination, OpCodes, Arguments}
  alias CEC.Mapping.{DeckStatus, DeckStatusRequest}
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

  def map_arguments(opcode, arguments) do
    case opcode |> map_opcode do
      :deck_status -> %{status: arguments |> List.first |> DeckStatus.from_code}
      :give_deck_status -> %{status: arguments |> List.first |> DeckStatusRequest.from_code}
      :device_vendor_id -> %{vendor: Arguments.to_vendor(arguments)}
      :set_osd_name -> %{value: Arguments.to_ascii(arguments)}


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
