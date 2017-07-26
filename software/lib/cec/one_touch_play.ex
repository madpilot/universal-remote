defmodule CEC.OneTouchPlay do
  def active_source(source, destination, address) do
    CEC.send(source, destination, 0x82, [ address ])
  end

  def image_view_on(source, destination \\ :tv) do
    CEC.send(source, destination, 0x04)
  end

  def text_view_on(source, destination \\ :tv) do
    CEC.send(source, destination, 0x0d)
  end
end
