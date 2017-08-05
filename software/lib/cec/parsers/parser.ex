defmodule CEC.Parsers.Parser do
  alias CEC.Mapping.{Source, Destination, OpCodes}
  alias CEC.Parsers.{Arguments}

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
      :active_source -> %{address: Arguments.to_address(arguments)}
      :cec_version -> %{version: CEC.Parsers.Version.version(arguments)}
      :clear_analogur_timer -> raise "Not implemented"
      :clear_digital_timer -> raise "Not implemented"
      :clear_external_timer -> raise "Not implemented"
      :deck_control -> %{mode: CEC.Parsers.DeckControl.deck_control(arguments)}
      :deck_status -> %{status: CEC.Parsers.DeckControl.deck_status(arguments)}
      :device_vendor_id -> %{vendor: Arguments.to_vendor(arguments)}
      :feature_abort -> CEC.Parsers.Abort.feature_abort(arguments)
      :give_deck_status -> %{status: CEC.Parsers.DeckControl.give_deck_status(arguments)}

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
    |> String.trim
    |> String.split(":")
    |> process
  end
end
