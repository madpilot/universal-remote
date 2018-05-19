defmodule ListenerSpec do
  use ESpec

  describe "listen_for" do
    before do
      {:ok, pid} = Devices.Listener.listen_for(filter(), self())
      CEC.SystemAudioControl.give_audio_status(:tv, :audio_system)
      CEC.SystemInformation.cec_version(:tuner_2, :audio_system, "1.1")
      Process.exit(pid, :normal)
    end

    describe "timeout" do
      let :filter, do: %{bus: :lirc}

      it "sends an error" do
        refute_receive {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end

    describe "success" do
      let :filter, do: %{bus: :cec, command: :cec_version}

      it "sends the event" do
        assert_receive {:matched, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}
      end
    end
  end
end
