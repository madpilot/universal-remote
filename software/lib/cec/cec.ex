defmodule CEC do
  def send_code(code) do
    CEC.Process.send_code(code)
  end
end
