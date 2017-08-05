defmodule CEC.Mapping.Versions do
  def to_code(version) do
    case version do
      "1.1" -> 0x00
      "1.2" -> 0x01
      "1.2a" -> 0x02
      "1.3" -> 0x03
      "1.3a" -> 0x04
    end
  end

  def from_code(code) do
    case code do
      0x00 -> "1.1"
      0x01 -> "1.2"
      0x02 -> "1.2a"
      0x03 -> "1.3"
      0x04 -> "1.3a"
    end
  end
end
