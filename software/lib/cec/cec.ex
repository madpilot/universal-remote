defmodule CEC do
  alias CEC.Mapping.Devices
  use Bitwise, only_operators: true

  defp hex_elements(list) do
    list
    |> Enum.map(fn(i) -> Integer.to_string(i, 16) end)
  end

  defp prepare_code(code) do
    code
    |> Enum.join(":")
  end

  defp prepare_devices(tail, sender, receiver) do
    address = [ Devices.to_code(sender), Devices.to_code(receiver) ]
    |> hex_elements
    |> Enum.join("")

    [ address | tail ]
  end

  defp prepare_command(tail, command) do
    [ command |> Integer.to_string(16) |> String.rjust(2, ?0) | tail ]
  end

  # Need to group into bytes
  defp prepare_address(tail, address) do
    case address do
      [] -> tail
       _ -> (
              byte = address
                |> Enum.slice(0..1)
                |> Enum.map(fn(c) -> String.to_integer(c) end)
                |> hex_elements
                |> Enum.join("")

              [byte | prepare_address(tail, Enum.drop(address, 2))]
            )
    end
  end

  defp prepare_charlist(tail, list) do
    ints =  list
      |> hex_elements

    ints ++ tail
  end

  def prepare_integer(tail, integer) do
    head = integer
    |> Integer.to_string(16)
    |> String.rjust(2, ?0)

    [head | tail]
  end

  defp prepare_argument(tail, arg) when is_binary(arg) do
    cond do
      String.match?(arg, ~r/(\d)\.(\d)\.(\d)\.(\d)/)  -> prepare_address(tail, String.split(arg, "."))
                                                  arg -> prepare_charlist(tail, String.to_charlist(arg))
    end
  end

  defp prepare_argument(tail, arg) when is_integer(arg) do
    tail
    |> prepare_integer(arg)
  end

  defp prepare_arguments(tail, args) do
    args
    |> Enum.reverse
    |> Enum.reduce(tail, fn(arg, tail) -> prepare_argument(tail, arg) end)
  end

  def code(sender, receiver, command, args \\ []) do
    []
    |> prepare_arguments(args)
    |> prepare_command(command)
    |> prepare_devices(sender, receiver)
    |> prepare_code
  end

  def code(sender, receiver) do
    []
    |> prepare_devices(sender, receiver)
    |> prepare_code
  end

  def send(sender, receiver, command, args \\ []) do
    sender
    |> code(receiver, command, args)
    |> CEC.Process.send_code
  end

  def send(sender, receiver) do
    sender
    |> code(receiver)
    |> CEC.Process.send_code
  end
end
