defmodule CEC.Parsers.ParserSpec do
  use ESpec

  alias CEC.Parsers.Parser

  describe "abort" do
    it "parses message" do
      expect(Parser.from_code("01:FF")) |> to(eq %{source: :tv, destination: :recording_1, command: :abort})
    end
  end

  describe "active_source" do
    it "parses message" do
      expect(Parser.from_code("60:82:31:00")) |> to(eq %{source: :tuner_2, destination: :tv, command: :active_source, address: "3.1.0.0"})
    end
  end

  describe "cec_version" do
    it "parses message" do
      expect(Parser.from_code("60:9E:01")) |> to(eq %{source: :tuner_2, destination: :tv, command: :cec_version, version: "1.2"})
    end
  end
end
