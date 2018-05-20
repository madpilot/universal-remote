defmodule OneShotListenerSpec do
  use ESpec, async: false

  describe "listen_for" do
    let :event, do: %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}
    let :state, do: %{filter: filter(), caller: self()}
    subject do: Devices.OneShotListener.handle_events([event()], nil, state())

    describe "complete mismatch" do
      let :filter, do: %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.2"}

      it "sends no message" do
        expect subject() |> to(eq({:noreply, [], state()}))
        refute_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end

    describe "partial mismatch" do
      let :filter, do: %{bus: :lirc}

      it "sends no message" do
        expect subject() |> to(eq({:noreply, [], state()}))
        refute_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end

    describe "partial filter match" do
      let :filter, do: %{bus: :cec, command: :cec_version}

      it "sends the event" do
        expect subject() |> to(eq({:stop, :normal, state()}))
        assert_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end

    describe "complete filter match" do
      let :filter, do: %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}

      it "sends the event" do
        expect subject() |> to(eq({:stop, :normal, state()}))
        assert_received {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end
  end
end
