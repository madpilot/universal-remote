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
      :deck_control -> %{mode: CEC.Parsers.DeckControl.deck_control(arguments)}
      :deck_status -> %{status: CEC.Parsers.DeckControl.deck_status(arguments)}
      :device_vendor_id -> %{vendor: Arguments.to_vendor(arguments)}
      :feature_abort -> CEC.Parsers.Abort.feature_abort(arguments)
      :give_deck_status -> %{status: CEC.Parsers.DeckControl.give_deck_status(arguments)}
      :inactive_source -> %{address: Arguments.to_address(arguments)}
      :menu_status -> %{state: CEC.Parsers.DeviceMenuControl.menu_status(arguments)}
      :menu_request -> %{type: CEC.Parsers.DeviceMenuControl.menu_request(arguments)}
      :report_physical_address -> CEC.Parsers.SystemInformation.report_physical_address(arguments)
      :report_audio_status -> CEC.Parsers.SystemAudioControl.give_audio_status(arguments)
      :report_power_status -> %{status: CEC.Parsers.DevicePowerStatus.report_power_status(arguments)}
      :routing_change -> CEC.Parsers.SystemInformation.routing_change(arguments)
      :routing_information -> %{address: Arguments.to_address(arguments)}
      :set_menu_language -> %{language: Arguments.to_ascii(arguments)}
      :set_osd_name -> %{value: Arguments.to_ascii(arguments)}
      :set_stream_path -> %{address: Arguments.to_address(arguments)}
      :user_pressed -> %{key: CEC.Parsers.ControlCodes.user_pressed(arguments)}
      :vendor_command -> %{code: arguments |> Enum.join(":")}
      :vendor_remote_button_down -> %{code: arguments |> Enum.join(":")}
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
