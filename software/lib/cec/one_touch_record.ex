defmodule CEC.OneTouchRecord do
  alias CEC.Mapping.{Sources,RecordErrors}

  def record_on(source, destination, record_source) do
    CEC.send(source, destination, 0x09, [Sources.to_code(record_source)])
  end

  def record_off(source, destination) do
    CEC.send(source, destination, 0x0b)
  end

  def record_status(source, destination, status) do
    cond do
      Sources.to_code(status) in 0x1..0x4 -> CEC.send(source, destination, 0x0a, [Sources.to_code(status)])
                                     true -> CEC.send(source, destination, 0x0a, [RecordErrors.to_code(status)])
    end
  end

  def record_tv_screen(source, destination) do
    CEC.send(source, destination, 0x0f)
  end
end
