defmodule RemotesSpec do
  use ESpec

  describe "map of remotes" do
    let :initial, do: %{}
    let! :pid, do: GenServer.start_link(Remotes, initial()) |> elem(1)
    finally do: Process.exit(pid(), :normal)

    describe "init" do
      subject do: Remotes.init(initial())

      it "sets the initial state" do
        expect(subject()) |> to(eq {:ok, initial()})
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

    describe "list" do
      subject do: GenServer.call(pid(), {:list})

      it "registers the module" do
        GenServer.call(pid(), {:register, :cec, CEC.Remote})
        expect(subject()) |> to(eq %{cec: CEC.Remote})
      end
    end
  end
end
