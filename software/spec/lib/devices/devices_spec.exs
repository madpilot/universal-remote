defmodule DevicesSpec do
  use ESpec

  describe "map of Devices" do
    let :initial, do: %{}
    let! :pid, do: GenServer.start_link(Devices, initial()) |> elem(1)
    finally do: Process.exit(pid(), :normal)

    describe "init" do
      subject do: Devices.init(initial())

      it "sets the initial state" do
        expect(subject()) |> to(eq {:ok, initial()})
      end

      context "non-empty initial state" do
        let :path, do: "spec/fixtures/test_device.exs"
        let :initial, do: %{test: path()}

        it "should attempt to load the file" do
          subject()
        end
      end
    end

    describe "register" do
      subject do: GenServer.call(pid(), {:list})

      it "registers the module" do
        GenServer.call(pid(), {:register, :cec, CEC.Remote})
        expect(subject()) |> to(eq %{cec: CEC.Remote})
      end
    end

    describe "deregister" do
      subject do: GenServer.call(pid(), {:list})
      before do: GenServer.call(pid(), {:register, :cec, CEC.Remote})

      it "registers the module" do
        GenServer.call(pid(), {:deregister, :cec})
        expect(subject()) |> to(eq %{})
      end
    end

    describe "registered" do
      let :name, do: :cec
      let :test, do: :cec
      subject do: GenServer.call(pid(), {:registered, test()})
      before do: GenServer.call(pid(), {:register, name(), CEC.Remote})

      describe "name exists" do
        let :name, do: :cec

        it "returns true" do
          expect(subject()) |> to(eq true)
        end
      end

      describe "name does not exist" do
        let :test, do: :lirc

        it "returns false" do
          expect(subject()) |> to(eq false)
        end
      end
    end

    describe "get" do
      let :name, do: :cec
      let :test, do: :cec

      subject do: GenServer.call(pid(), {:get, test()})
      before do: GenServer.call(pid(), {:register, name(), CEC.Remote})

      describe "name exists" do
        let :name, do: :cec

        it "returns the module" do
          expect(subject()) |> to(eq {:ok, CEC.Remote})
        end
      end

      describe "name does not exist" do
        let :test, do: :lirc

        it "returns an error" do
          expect(subject()) |> to(eq {:unknown_device})
        end
      end
    end

    describe "list" do
      subject do: GenServer.call(pid(), {:list})

      it "registers the module" do
        GenServer.call(pid(), {:register, :cec, CEC.Remote})
        expect(subject()) |> to(eq %{cec: CEC.Remote})
      end
    end

    describe "send_once" do
      subject do: GenServer.call(pid(), {:send_once, :test, :key_power_on})
      describe "module exists" do
        let :initial, do: %{}
        before do: GenServer.call(pid(), {:register, :test, TestDevice})

        it "returns ok" do
          expect(subject()) |> to(eq {:ok, :send_once})
        end
      end

      describe "module does not exist" do
        let :initial, do: %{}

        it "returns unknown_device" do
          expect(subject()) |> to(eq {:unknown_device})
        end
      end
    end

    describe "send_start" do
      subject do: GenServer.call(pid(), {:send_start, :test, :key_power_on})
      describe "module exists" do
        let :initial, do: %{}
        before do: GenServer.call(pid(), {:register, :test, TestDevice})

        it "returns ok" do
          expect(subject()) |> to(eq {:ok, :send_start})
        end
      end

      describe "module does not exist" do
        let :initial, do: %{}

        it "returns unknown_device" do
          expect(subject()) |> to(eq {:unknown_device})
        end
      end
    end

    describe "send_stop" do
      subject do: GenServer.call(pid(), {:send_stop, :test, :key_power_on})
      describe "module exists" do
        let :initial, do: %{}
        before do: GenServer.call(pid(), {:register, :test, TestDevice})

        it "returns ok" do
          expect(subject()) |> to(eq {:ok, :send_stop})
        end
      end

      describe "module does not exist" do
        let :initial, do: %{}

        it "returns unknown_device" do
          expect(subject()) |> to(eq {:unknown_device})
        end
      end
    end
  end

  describe "Proxy methods" do
    let :initial, do: %{}

    describe "start_link" do
      before do: allow GenServer |> to(accept :start_link, fn(_, _, _) -> nil end)
      subject do: Devices.start_link(initial())

      it "calls GenServer.start_link" do
        subject()
        expect(GenServer) |> to(accepted :start_link, [Devices, initial(), [name: Devices]])
      end
    end

    describe "calls" do
      before do: allow GenServer |> to(accept :register, fn(_, _) -> nil end)

      describe "register" do
        before do: Devices.start_link(initial())
        subject do: Devices.register(:test, Test)

        it "calls registered via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:register, :test, Test}])
        end
      end

      describe "deregister" do
        before do: Devices.start_link(initial())
        subject do: Devices.deregister(:test)

        it "calls registered via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:deregister, :test}])
        end
      end

      describe "registered" do
        before do: Devices.start_link(initial())
        subject do: Devices.registered(:test)

        it "calls registered via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:registered, :test}])
        end
      end

      describe "get" do
        before do: Devices.start_link(initial())
        subject do: Devices.get(:test)

        it "calls get via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:get, :test}])
        end
      end

      describe "list" do
        before do: Devices.start_link(initial())
        subject do: Devices.list

        it "calls list via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:list}])
        end
      end

      describe "send_once" do
        let :name, do: :name
        let :command, do: :power_on
        before do: Devices.start_link(initial())
        subject do: Devices.send_once(name(), command())

        it "calls send via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:send_once, name(), command()}])
        end
      end

      describe "send_start" do
        let :name, do: :name
        let :command, do: :power_on
        before do: Devices.start_link(initial())
        subject do: Devices.send_start(name(), command())

        it "calls send via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:send_start, name(), command()}])
        end
      end

      describe "send_stop" do
        let :name, do: :name
        let :command, do: :power_on
        before do: Devices.start_link(initial())
        subject do: Devices.send_stop(name(), command())

        it "calls send via GenServer" do
          subject()
          expect(GenServer) |> to(accepted :call, [Devices, {:send_stop, name(), command()}])
        end
      end
    end
  end
end
