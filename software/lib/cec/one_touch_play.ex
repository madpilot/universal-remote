defmodule CEC.OneTouchPlay do
  alias CEC.Mapping.OpCodes

  def active_source(source, destination, address) do
    CEC.send(source, destination, OpCodes.to_code(:active_source), [ address ])
  end

  def image_view_on(source, destination \\ :tv) do
    CEC.send(source, destination, OpCodes.to_code(:image_view_on))
  end

  def text_view_on(source, destination \\ :tv) do
    CEC.send(source, destination,OpCodes.to_code(:text_view_on))
  end
end
