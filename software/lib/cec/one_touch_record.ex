defmodule CEC.OneTouchRecord do
  alias CEC.Mapping.Sources

  def record_off(source, destination) do
    CEC.send(source, destination, 0x0b)
  end

  def record_status(source, destination, status) do
    CEC.send(source, destination, 0x0a, [Sources.source_to_code(status)])
  end

  def record_tv_screen(source, destination) do
    CEC.send(source, destination, 0x0f)
  end
end
