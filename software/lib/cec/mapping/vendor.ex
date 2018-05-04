defmodule CEC.Mapping.Vendor do
  alias CEC.Mapping.Mapper

  def vendors do
    [
      toshiba: 0x000039,
      samsung: 0x0000F0,
      denon: 0x0005CD,
      marantz: 0x000678,
      loewe: 0x000982,
      onkyo: 0x0009B0,
      medion: 0x000CB8,
      toshiba_2: 0x000CE7,
      pulse_eight: 0x001582,
      harman_kardon_2: 0x001950,
      google: 0x001A11,
      akai: 0x0020C7,
      aoc: 0x002467,
      panasonic: 0x008045,
      philips: 0x00903E,
      daewoo: 0x009053,
      yamaha: 0x00A0DE,
      grundig: 0x00D0D5,
      pioneer: 0x00E036,
      lg: 0x00E091,
      sharp: 0x08001F,
      sony: 0x080046,
      broadcom: 0x18C086,
      sharp_2: 0x534850,
      vizio: 0x6B746D,
      benq: 0x8065E9,
      harman_kardon: 0x9C645E,
      unknown: 0x0
    ]
  end

  def to_code(vendor) do
    vendors()
    |> Mapper.to_code(vendor)
  end

  def from_code(code) do
    vendors()
    |> Mapper.from_code(code)
  end
end
