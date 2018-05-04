defmodule BusSpec do
  use ESpec

  describe "wait_for" do
    let :filter, do: %{bus: :cec, command: :cec_version}
    let :timeout, do: 1000

    let :subject, do: (Bus.wait_for(filter(), timeout()) do
      CEC.SystemAudioControl.give_audio_status(:tv, :audio_system)
      CEC.SystemInformation.cec_version(:tuner_2, :audio_system, "1.1")
    end)

    describe "timeout" do
      let :filter, do: %{bus: :lirc}
      let :timeout, do: 10

      it "return an error" do
        expect(subject()) |> to(eq({:timeout, "Status request timed out"}))
      end
    end

    describe "success" do
      it "returns the event" do
        expect(subject()) |> to(eq({:ok, %{bus: :cec, command: :cec_version, destination: :audio_system, source: :tuner_2, version: "1.1"}}))
      end
    end
  end
end
