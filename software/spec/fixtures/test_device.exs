defmodule TestDevice do
  use Device

  command :power_on, [:send_start, :send_stop, :send_once] do
    {:ok}
  end
end
