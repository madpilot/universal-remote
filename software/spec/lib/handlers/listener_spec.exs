defmodule ListenerSpec do
  use ESpec, async: false

  describe "listen_for" do
    let :event, do: %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}

    before do
      Devices.Listener.handle_events([event()], nil, %{filter: filter(), caller: self()})
    end

    describe "complete mismatch" do
      let :filter, do: %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.2"}

      it "sends no message" do
        refute_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end

    describe "partial mismatch" do
      let :filter, do: %{bus: :lirc}

      it "sends no message" do
        refute_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end

    describe "partial filter match" do
      let :filter, do: %{bus: :cec, command: :cec_version}

      it "sends the event" do
        assert_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end

    describe "complete filter match" do
      let :filter, do: %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}

      it "sends the event" do
        assert_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end
  end
end
