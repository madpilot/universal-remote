defmodule CEC.Mapping.VendorSpec do
  use ESpec
  alias CEC.Mapping.Vendor

  describe "source code mappings" do
    it "maps toshiba" do
      expect(Vendor.vendors[:toshiba]) |> to(eq(0x000039))
    end

    it "maps samsung" do
      expect(Vendor.vendors[:samsung]) |> to(eq(0x0000F0))
    end

    it "maps denon" do
      expect(Vendor.vendors[:denon]) |> to(eq(0x0005CD))
    end

    it "maps marantz" do
      expect(Vendor.vendors[:marantz]) |> to(eq(0x000678))
    end

    it "maps loewe" do
      expect(Vendor.vendors[:loewe]) |> to(eq(0x000982))
    end

    it "maps onkyo" do
      expect(Vendor.vendors[:onkyo]) |> to(eq(0x0009B0))
    end

    it "maps medion" do
      expect(Vendor.vendors[:medion]) |> to(eq(0x000CB8))
    end

    it "maps toshiba_2" do
      expect(Vendor.vendors[:toshiba_2]) |> to(eq(0x000CE7))
    end

    it "maps pulse_eight" do
      expect(Vendor.vendors[:pulse_eight]) |> to(eq(0x001582))
    end

    it "maps harman_kardon_2" do
      expect(Vendor.vendors[:harman_kardon_2]) |> to(eq(0x001950))
    end

    it "maps google" do
      expect(Vendor.vendors[:google]) |> to(eq(0x001A11))
    end

    it "maps akai" do
      expect(Vendor.vendors[:akai]) |> to(eq(0x0020C7))
    end

    it "maps aoc" do
      expect(Vendor.vendors[:aoc]) |> to(eq(0x002467))
    end

    it "maps panasonic" do
      expect(Vendor.vendors[:panasonic]) |> to(eq(0x008045))
    end

    it "maps philips" do
      expect(Vendor.vendors[:philips]) |> to(eq(0x00903E))
    end

    it "maps daewoo" do
      expect(Vendor.vendors[:daewoo]) |> to(eq(0x009053))
    end

    it "maps yamaha" do
      expect(Vendor.vendors[:yamaha]) |> to(eq(0x00A0DE))
    end

    it "maps grundig" do
      expect(Vendor.vendors[:grundig]) |> to(eq(0x00D0D5))
    end

    it "maps pioneer" do
      expect(Vendor.vendors[:pioneer]) |> to(eq(0x00E036))
    end

    it "maps lg" do
      expect(Vendor.vendors[:lg]) |> to(eq(0x00E091))
    end

    it "maps sharp" do
      expect(Vendor.vendors[:sharp]) |> to(eq(0x08001F))
    end

    it "maps sony" do
      expect(Vendor.vendors[:sony]) |> to(eq(0x080046))
    end

    it "maps broadcom" do
      expect(Vendor.vendors[:broadcom]) |> to(eq(0x18C086))
    end

    it "maps sharp_2" do
      expect(Vendor.vendors[:sharp_2]) |> to(eq(0x534850))
    end

    it "maps vizio" do
      expect(Vendor.vendors[:vizio]) |> to(eq(0x6B746D))
    end

    it "maps benq" do
      expect(Vendor.vendors[:benq]) |> to(eq(0x8065E9))
    end

    it "maps harman_kardon" do
      expect(Vendor.vendors[:harman_kardon]) |> to(eq(0x9C645E))
    end

    it "maps unknown" do
      expect(Vendor.vendors[:unknown]) |> to(eq(0x0))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(Vendor.to_code(:toshiba_2)) |> to(eq(0x000CE7))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(Vendor.from_code(0x0020C7)) |> to(eq(:akai))
    end
  end
end
