defmodule Server.Web.Devices.RouterSpec do
  use ESpec
  use Plug.Test

  alias Server.Web.Devices.Router

  describe "Server.Web.Devices.RouterSpec" do
    describe "/" do
      let :response, do: conn(:get, "/") |> Router.call([])

      it "returns a 200" do
        expect(response().status) |> to(eq 200)
      end

      it "returns a list of all the remotes registered" do
        expect(response().resp_body |> Poison.decode! |> Access.get("devices")) |> to(eq(["test_device", "test_device2"]))
      end
    end

    describe "/:device" do
      let :device, do: "test_device"

      let :response, do: conn(:get, "/#{device()}") |> Router.call([])

      describe "a device that is registered" do
        let :device, do: "test_device"

        it "returns a 200" do
          expect(response().status) |> to(eq 200)
        end

        it "returns the device name" do
          expect(response().resp_body |> Poison.decode! |> Access.get("device")) |> to(eq(device()))
        end

        it "returns metadata" do
          expect(response().resp_body |> Poison.decode! |> Access.get("metadata")) |> to(eq(%{"name" => "Test Device"}))
        end

        it "returns a list of commands" do
          expect(response().resp_body |> Poison.decode! |> Access.get("commands") |> Enum.sort) |> to(eq(["key_power_on", "key_power_off", "key_standby", "key_volumedown", "key_volumeup"] |> Enum.sort))
        end

        it "returns a list of statuses" do
          expect(response().resp_body |> Poison.decode! |> Access.get("statuses") |> Enum.sort) |> to(eq(["volume", "mute"] |> Enum.sort))
        end
      end

      describe "a device that is not registered" do
        let :device, do: "not_exists"

        it "returns a 404" do
          expect(response().status) |> to(eq 404)
        end

        it "returns an error message" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
        end
      end
    end

    describe "/:device/send" do
      let :device, do: "test_device"
      let :command, do: "key_power_on"

      let :response, do: conn(:put, "/#{device()}/send", "{\"command\":\"#{command()}\"}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "a device that is registered" do
        let :device, do: "test_device"

        describe "a command that exists" do
          let :command, do: "key_power_on"

          it "returns a 200" do
            expect(response().status) |> to(eq 200)
          end
        end

        describe "a command that doesn't exist" do
          let :command, do: "not_exists"

          it "returns a 404" do
            expect(response().status) |> to(eq 404)
          end

          it "returns an error message" do
            expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
          end
        end
      end

      describe "a device that doesn't exist" do
        let :device, do: "not_exists"

        it "returns a 404" do
          expect(response().status) |> to(eq 404)
        end

        it "returns an error message" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
        end
      end
    end

    describe "/:device/start" do
      let :device, do: "test_device"
      let :command, do: "key_power_on"

      let :response, do: conn(:put, "/#{device()}/start", "{\"command\":\"#{command()}\"}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "a device that is registered" do
        let :device, do: "test_device"

        describe "a command that exists" do
          let :command, do: "key_power_on"

          it "returns a 200" do
            expect(response().status) |> to(eq 200)
          end
        end

        describe "a command that doesn't exist" do
          let :command, do: "not_exists"

          it "returns a 404" do
            expect(response().status) |> to(eq 404)
          end

          it "returns an error message" do
            expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
          end
        end
      end

      describe "a device that doesn't exist" do
        let :device, do: "not_exists"

        it "returns a 404" do
          expect(response().status) |> to(eq 404)
        end

        it "returns an error message" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
        end
      end
    end

    describe "/:device/stop" do
      let :device, do: "test_device"
      let :command, do: "key_power_on"

      let :response, do: conn(:put, "/#{device()}/start", "{\"command\":\"#{command()}\"}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "a device that is registered" do
        let :device, do: "test_device"

        describe "a command that exists" do
          let :command, do: "key_power_on"

          it "returns a 200" do
            expect(response().status) |> to(eq 200)
          end
        end

        describe "a command that doesn't exist" do
          let :command, do: "not_exists"

          it "returns a 404" do
            expect(response().status) |> to(eq 404)
          end

          it "returns an error message" do
            expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
          end
        end
      end

      describe "a device that doesn't exist" do
        let :device, do: "not_exists"

        it "returns a 404" do
          expect(response().status) |> to(eq 404)
        end

        it "returns an error message" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
        end
      end
    end

    describe "/:device/status" do
      let :device, do: "test_device"

      let :response, do: conn(:get, "/#{device()}/status") |> Router.call([])

      describe "a device that is registered" do
        let :device, do: "test_device"

        it "returns a 200" do
          expect(response().status) |> to(eq 200)
        end

        it "returns a list of statuses" do
          expect(response().resp_body |> Poison.decode! |> Map.get("statuses") |> Enum.sort) |> to(eq(["volume", "mute"] |> Enum.sort))
        end
      end

      describe "a device that is not registered" do
        let :device, do: "not_exists"

        it "returns a 404" do
          expect(response().status) |> to(eq 404)
        end

        it "returns an error message" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
        end
      end
    end

    describe "/:device/status/:status" do
      let :device, do: "test_device"
      let :status, do: "volume"

      let :response, do: conn(:get, "/#{device()}/status/#{status()}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "a device that is registered" do
        let :device, do: "test_device"

        describe "a status that exists" do
          let :status, do: "volume"

          it "returns a 200" do
            expect(response().status) |> to(eq 200)
          end

          it "returns the status" do
            expect(response().resp_body |> Poison.decode!) |> to(eq(%{"device" => device(), "status" => %{"volume" => 50}}))
          end
        end

        describe "a status that timed out" do
          let :status, do: "mute"

          it "returns a 408" do
            expect(response().status) |> to(eq 408)
          end

          it "returns an error message" do
            expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Status request timed out"}))
          end
        end

        describe "a status that doesn't exist" do
          let :status, do: "not_exists"

          it "returns a 404" do
            expect(response().status) |> to(eq 404)
          end

          it "returns an error message" do
            expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
          end
        end
      end

      describe "a device that doesn't exist" do
        let :device, do: "not_exists"

        it "returns a 404" do
          expect(response().status) |> to(eq 404)
        end

        it "returns an error message" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
        end
      end
    end
  end
end
