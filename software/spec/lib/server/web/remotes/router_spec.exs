defmodule MockRemote do
  @behaviour UniversalRemote.Remotes.Behaviour

  def devices do
    {:ok, ["test_device"]}
  end

  def commands(device) do
    case device do
      :exists -> {:ok, ["key_up", "key_down"]}
      :not_exists -> {:error, :not_a_device}
    end
  end

  def send_once(device, _) do
    case device do
      :exists -> {:ok}
      :not_exists -> {:error, :not_a_device}
    end
  end

  def send_start(device, _) do
    case device do
      :exists -> {:ok}
      :not_exists -> {:error, :not_a_device}
    end
  end

  def send_stop(device, _) do
    case device do
      :exists -> {:ok}
      :not_exists -> {:error, :not_a_device}
    end
  end
end

defmodule Server.Web.Remotes.RouterSpec do
  use ESpec
  use Plug.Test

  alias Server.Web.Remotes.Router

  @opts Router.init([])

  describe "Server.Web.Remotes.RouterSpec" do
    before do: Remotes.register(:test, MockRemote)
    finally do: Remotes.deregister(:test)

    describe "/" do
      let :response, do: conn(:get, "/") |> Router.call([])

      it "returns a 200" do
        expect(response().status) |> to(eq 200)
      end

      it "returns a list of all the remotes registered" do
        expect(response().resp_body |> Poison.decode!) |> to(eq(["cec", "lirc", "test"]))
      end
    end

    describe "/:bus" do
      let :bus, do: "test"
      let :response, do: conn(:get, "/#{bus()}") |> Router.call([])

      describe "bus that is registered" do
        let :bus, do: "test"

        it "returns a 200" do
          expect(response().status) |> to(eq 200)
        end

        it "returns a list of devices" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(["test_device"]))
        end
      end

      describe "bus that is not registered" do
        let :bus, do: "foo"

        it "returns a 404" do
          expect(response().status) |> to(eq 404)
        end

        it "returns an error message" do
          expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
        end
      end
    end

    describe "/:bus/:device" do
      let :bus, do: "test"
      let :device, do: "foxtel"

      let :response, do: conn(:get, "/#{bus()}/#{device()}") |> Router.call([])

      describe "bus that is registered" do
        let :bus, do: "test"

        describe "a device that is registered" do
          let :device, do: "exists"

          it "returns a 200" do
            expect(response().status) |> to(eq 200)
          end

          it "returns a list of keys" do
            expect(response().resp_body |> Poison.decode!) |> to(eq(["key_up", "key_down"]))
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

      describe "bus that is not registered" do
        let :bus, do: "foo"

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
