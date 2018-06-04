defmodule Devices.LoaderSpec do
  use ESpec, async: false
  let :file, do: "spec/fixtures/test_device_3.exs"

  describe "initialization" do
    it "loads all the files in the supplied paths" do
      expect(Devices.Loader.loaded("spec/autoload_fixtures/test_device.exs")) |> to(eq(true))
      expect(Devices.Loader.loaded("spec/autoload_fixtures/test_device_2.exs")) |> to(eq(true))
    end

    it "registers all corresponding modules" do
      expect(Code.ensure_compiled?(TestDevice)) |> to(eq(true))
      expect(Code.ensure_compiled?(TestDevice2)) |> to(eq(true))
    end
  end

  describe "loading a file" do
    subject do: Devices.Loader.load(file())
    finally do: Devices.Loader.unload(file())

    describe "that has already been loaded" do
      describe "where the module name is the same" do
        it "reloads the module"
        it "does not register the device"
      end

      describe "where the module name is different" do
        it "loads the module"
        it "registers the device"
      end
    end

    describe "that has not already been loaded" do
      it "loads the module" do
        subject()
        expect(Code.ensure_compiled?(TestDevice3)) |> to(eq(true))
      end

      it "registers the device" do
        subject()
        expect(Devices.list[:test_device3]) |> to(eq(TestDevice3))
      end
    end
  end

  describe "unloading a file" do
    subject do: Devices.Loader.unload(file())

    describe "that has already been loaded" do
      before do: Devices.Loader.load(file())

      it "deregisters the device" do
        subject()
        expect(Devices.list[:test_device3]) |> to(eq(nil))
      end

      it "unloads the module" do
        subject()
        expect(Code.ensure_compiled?(TestDevice3)) |> to(eq(false))
      end
    end

    describe "that has not already been loaded" do
      it "does nothing" do
        expect(subject()) |> to(eq(:ok))
      end
    end
  end
end
