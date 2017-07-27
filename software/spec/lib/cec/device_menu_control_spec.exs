defmodule CEC.RemoteControlPassthroughSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "user_pressed" do
    it "receives the correct code" do
      CEC.DeviceMenuControl.user_pressed(:unregistered, :tv, :power_on_function)
      assert_receive("F0:44:6D")
    end
  end

  describe "user_released" do
    it "receives the correct code" do
      CEC.DeviceMenuControl.user_released(:unregistered, :tv)
      assert_receive("F0:45")
    end
  end

  describe "menu_response" do
    it "receives the correct code" do
      CEC.DeviceMenuControl.user_released(:unregistered, :tv, :activate)
      assert_receive("F0:8D:00")
    end
  end

  describe "menu_status" do
    it "receives the correct code" do
      CEC.DeviceMenuControl.user_released(:unregistered, :tv, :deactivated)
      assert_receive("F0:8E:01")
    end
  end
end
