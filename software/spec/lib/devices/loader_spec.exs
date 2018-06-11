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
    let :file_1, do: "spec/fixtures/test_loading_file_1.exs"
    let :file_2, do: "spec/fixtures/test_loading_file_2.exs"
    let :file_3, do: "spec/fixtures/test_loading_file_3.exs"
    let :file, do: "spec/fixtures/test_loading_file.exs"
    subject do: Devices.Loader.load(file())

    before do
      File.cp!(file_1(), file())
    end

    finally do
      Devices.Loader.unload(file())
      File.rm(file())
    end

    describe "that has already been loaded" do
      describe "where the module name is the same" do
        before do
          Devices.Loader.load(file())
          File.cp!(file_2(), file())
          Devices.Loader.load(file())
        end

        it "reloads the module" do
          expect(TestLoadingFile.name) |> to(eq("loading_file_2"))
        end

        it "it kills the old device genserver"

        it "starts the new device genserver"
      end

      describe "where the module name is different" do
        before do
          Devices.Loader.load(file())
          File.cp!(file_3(), file())
          Devices.Loader.load(file())
        end

        it "unregisters the old device" do
          expect(Devices.list[:test_loading_file]) |> to(eq(nil))
        end

        it "unloads the old module name" do
          expect(Code.ensure_compiled?(TestLoadingFile)) |> to(eq(false))
        end

        it "it kills the old device genserver"

        it "loads the module" do
          expect(Code.ensure_compiled?(TestLoadingFile3)) |> to(eq(true))
        end

        it "registers the device" do
          expect(Devices.list[:test_loading_file3]) |> to(eq(TestLoadingFile3))
        end

        it "starts the new device genserver"
      end
    end

    describe "that has not already been loaded" do
      it "loads the module" do
        expect(Code.ensure_compiled?(TestLoadingFile)) |> to(eq(false))
        subject()
        expect(Code.ensure_compiled?(TestLoadingFile)) |> to(eq(true))
      end

      it "registers the device" do
        expect(Devices.list[:test_loading_file]) |> to(eq(nil))
        subject()
        expect(Devices.list[:test_loading_file]) |> to(eq(TestLoadingFile))
      end
    end
  end

  describe "unloading a file" do
    subject do: Devices.Loader.unload(file())

    describe "that has already been loaded" do
      before do: Devices.Loader.load(file())

      it "deregisters the device" do
        expect(Devices.list[:test_device3]) |> to(eq(TestDevice3))
        subject()
        expect(Devices.list[:test_device3]) |> to(eq(nil))
      end

      it "unloads the module" do
        expect(Code.ensure_compiled?(TestDevice3)) |> to(eq(true))
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
