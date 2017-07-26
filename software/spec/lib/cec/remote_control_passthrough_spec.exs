defmodule CEC.RemoteControlPassthroughSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "user_pressed" do
    it "receives the correct code" do
      CEC.RemoteControlPassthrough.user_pressed(:unregistered, :tv, :power_on_function)
      assert_receive("F0:44:6D")
    end
  end

  describe "user_released" do
    it "receives the correct code" do
      CEC.RemoteControlPassthrough.user_released(:unregistered, :tv)
      assert_receive("F0:45")
    end
  end
end
