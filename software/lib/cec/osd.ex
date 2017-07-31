defmodule CEC.OSD do
  alias CEC.Mapping.Display

  def set_osd_string(source, destination, display, string) do
    CEC.send(source, destination, 0x64, [Display.to_code(display), string])
  end
end
