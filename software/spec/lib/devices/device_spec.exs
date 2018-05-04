defmodule DeviceSpec do
  use ESpec

  describe "dsl" do
    describe "command" do
      it "turns a command block into a function" do
        expect(:erlang.function_exported(TestDevice, :key_power_on, 1)) |> to(eq true)
      end

      context "send_start" do
        context "exists" do
          expect(TestDevice.key_power_on(:send_start)) |> to(eq {:ok, :send_start})
        end

        context "does not exist" do
          expect(TestDevice.key_power_off(:send_start)) |> to(eq nil)
        end
      end

      context "send_stop" do
        context "exists" do
          expect(TestDevice.key_power_on(:send_stop)) |> to(eq {:ok, :send_stop})
        end

        context "does not exist" do
          expect(TestDevice.key_power_off(:send_stop)) |> to(eq nil)
        end
      end

      context "send_once" do
        context "exists" do
          expect(TestDevice.key_power_on(:send_once)) |> to(eq {:ok, :send_once})
        end

        context "does not exist" do
          expect(TestDevice.key_standby(:send_once)) |> to(eq nil)
        end
      end
    end

    describe "passthrough" do
      context "to another device" do
        it "calls the passed through function"
      end

      context "to a remote" do
        it "calls the passed through action with the function name"
      end
    end
  end
end
