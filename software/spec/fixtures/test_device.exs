defmodule TestDevice do
  use Device

  command :power_on do
    {:ok}
  end
end
