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
        expect(response().resp_body |> Poison.decode!) |> to(eq(["test_device"]))
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

        it "returns a list of commands" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(["power_on"]))
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
      let :command, do: "power_on"

      let :response, do: conn(:put, "/#{device()}/send", "{\"command\":\"#{command()}\"}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "a device that is registered" do
        let :device, do: "test_device"

        describe "a command that exists" do
          let :command, do: "power_on"

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
  end
end
