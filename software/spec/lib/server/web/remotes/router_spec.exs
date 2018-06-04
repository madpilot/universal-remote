defmodule MockRemote do
  @behaviour UniversalRemote.Remotes.Behaviour

  def devices do
    {:ok, ["test_remote"]}
  end

  def commands(remote) do
    case remote do
      :exists -> {:ok, ["key_up", "key_down"]}
      :not_exists -> {:unknown_remote}
    end
  end

  def send_once(remote, key) do
    case remote do
      :exists -> case key do
        :exists -> {:ok}
        :not_exists -> {:unknown_command}
      end
      :not_exists -> {:unknown_remote}
    end
  end

  def send_start(remote, key) do
    case remote do
      :exists -> case key do
        :exists -> {:ok}
        :not_exists -> {:unknown_command}
      end
      :not_exists -> {:unknown_remote}
    end
  end

  def send_stop(remote, key) do
    case remote do
      :exists -> case key do
        :exists -> {:ok}
        :not_exists -> {:unknown_command}
      end
      :not_exists -> {:unknown_remote}
    end
  end

  def send(type, device, key) do
    case type do
      :send_once -> send_once(device, key)
      :send_start -> send_start(device, key)
      :send_stop -> send_stop(device, key)
    end
  end
end

defmodule Server.Web.Remotes.RouterSpec do
  use ESpec
  use Plug.Test

  alias Server.Web.Remotes.Router

  describe "Server.Web.Remotes.RouterSpec" do
    before do: Remotes.register(:test, MockRemote)
    finally do: Remotes.deregister(:test)

    describe "/" do
      let :response, do: conn(:get, "/") |> Router.call([])

      it "returns a 200" do
        expect(response().status) |> to(eq 200)
      end

      it "returns a list of all the remotes registered" do
        expect(response().resp_body |> Poison.decode! |> Access.get("remotes")) |> to(eq(["cec", "lirc", "test"]))
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

        it "returns a list of remotes" do
          expect(response().resp_body |> Poison.decode! |> Access.get("remotes")) |> to(eq(["test_remote"]))
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

    describe "/:bus/:remote" do
      let :bus, do: "test"
      let :remote, do: "foxtel"

      let :response, do: conn(:get, "/#{bus()}/#{remote()}") |> Router.call([])

      describe "bus that is registered" do
        let :bus, do: "test"

        describe "a remote that is registered" do
          let :remote, do: "exists"

          it "returns a 200" do
            expect(response().status) |> to(eq 200)
          end

          it "returns the remote name" do
            expect(response().resp_body |> Poison.decode! |> Access.get("remote")) |> to(eq(remote()))
          end

          it "returns a list of keys" do
            expect(response().resp_body |> Poison.decode! |> Access.get("keys")) |> to(eq(["key_up", "key_down"]))
          end
        end

        describe "a remote that is not registered" do
          let :remote, do: "not_exists"

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

    describe "/:bus/:remote/send" do
      let :bus, do: "test"
      let :remote, do: "exists"
      let :key, do: "exists"

      let :response, do: conn(:put, "/#{bus()}/#{remote()}/send", "{\"key\":\"#{key()}\"}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "bus that is registered" do
        let :bus, do: "test"

        describe "a remote that is registered" do
          let :remote, do: "exists"

          describe "a command that exists" do
            let :key, do: "exists"

            it "returns a 200" do
              expect(response().status) |> to(eq 200)
            end
          end

          describe "a command that doesn't exist" do
            let :key, do: "not_exists"

            it "returns a 404" do
              expect(response().status) |> to(eq 404)
            end

            it "returns an error message" do
              expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
            end
          end
        end

        describe "a remote that doesn't exist" do
          let :remote, do: "not_exists"

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

    describe "/:bus/:remote/start" do
      let :bus, do: "test"
      let :remote, do: "exists"
      let :key, do: "exists"

      let :response, do: conn(:put, "/#{bus()}/#{remote()}/start", "{\"key\":\"#{key()}\"}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "bus that is registered" do
        let :bus, do: "test"

        describe "a remote that is registered" do
          let :remote, do: "exists"

          describe "a command that exists" do
            let :key, do: "exists"

            it "returns a 200" do
              expect(response().status) |> to(eq 200)
            end
          end

          describe "a command that doesn't exist" do
            let :key, do: "not_exists"

            it "returns a 404" do
              expect(response().status) |> to(eq 404)
            end

            it "returns an error message" do
              expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
            end
          end
        end

        describe "a remote that doesn't exist" do
          let :remote, do: "not_exists"

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

    describe "/:bus/:remote/stop" do
      let :bus, do: "test"
      let :remote, do: "exists"
      let :key, do: "exists"

      let :response, do: conn(:put, "/#{bus()}/#{remote()}/stop", "{\"key\":\"#{key()}\"}")
        |> put_req_header("content-type", "application/json")
        |> Router.call([])

      describe "bus that is registered" do
        let :bus, do: "test"

        describe "a remote that is registered" do
          let :remote, do: "exists"

          describe "a command that exists" do
            let :key, do: "exists"

            it "returns a 200" do
              expect(response().status) |> to(eq 200)
            end
          end

          describe "a command that doesn't exist" do
            let :key, do: "not_exists"

            it "returns a 404" do
              expect(response().status) |> to(eq 404)
            end

            it "returns an error message" do
              expect(response().resp_body |> Poison.decode!) |> to(eq(%{"error" => "Not Found"}))
            end
          end
        end

        describe "a remote that doesn't exist" do
          let :remote, do: "not_exists"

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
