defmodule Devices.FilewatcherSpec do
  use ESpec

  describe "handle_file_event" do
    subject do: Devices.Filewatcher.handle_file_event(events(), path())
    let :path, do: "/fake_file.exs"
    let :events, do: []

    before do: allow(Devices.Loader).to accept(:load)
    before do: allow(Devices.Loader).to accept(:reload)
    before do: allow(Devices.Loader).to accept(:unload)

    describe "file removed" do
      let :events, do: [:removed]

      it "is marked as removed" do
        subject()
        expect(Devices.Loader).to accepted(:unload)
      end
    end

    describe "file creation" do
      let :events, do: [:created]

      it "is marked as created" do
        subject()
        expect(Devices.Loader).to accepted(:load)
      end

      describe "with file modification" do
        let :events, do: [:created, :modified]

        it "is marked as created" do
          subject()
          expect(Devices.Loader).to accepted(:load)
        end
      end
    end

    describe "file update" do
      let :events, do: [:modified]

      it "is marked as updated" do
        subject()
        expect(Devices.Loader).to accepted(:reload)
      end

      describe "temporary file technique" do
        let :events, do: [:created, :renamed, :modified, :changeowner]

        it "is marked as updated" do
          subject()
          expect(Devices.Loader).to accepted(:reload)
        end
      end
    end
  end
end
