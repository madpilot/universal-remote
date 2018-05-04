defmodule CEC.OSD do
  alias CEC.Mapping.OpCodes
  alias CEC.Mapping.Display

  def set_osd_string(source, destination, display, string) do
    CEC.send(source, destination, OpCodes.to_code(:set_osd_string), [Display.to_code(display), string])
  end
end
