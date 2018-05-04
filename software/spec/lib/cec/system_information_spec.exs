defmodule CEC.SystemInformationSpec do
  use ESpec

  before do: allow CEC.Process |> to(accept :send_code, fn(code) -> send(self(), code) end)

  describe "cec_version" do
    describe "version 1.1" do
      it "receives the correct code" do
        CEC.SystemInformation.cec_version(:tuner_2, :audio_system, "1.1")
        assert_receive("65:9E:00")
      end
    end

    describe "version 1.2" do
      it "receives the correct code" do
        CEC.SystemInformation.cec_version(:tuner_2, :audio_system, "1.2")
        assert_receive("65:9E:01")
      end
    end

    describe "version 1.2a" do
      it "receives the correct code" do
        CEC.SystemInformation.cec_version(:tuner_2, :audio_system, "1.2a")
        assert_receive("65:9E:02")
      end
    end

    describe "version 1.3" do
      it "receives the correct code" do
        CEC.SystemInformation.cec_version(:tuner_2, :audio_system, "1.3")
        assert_receive("65:9E:03")
      end
    end

    describe "version 1.3a" do
      it "receives the correct code" do
        CEC.SystemInformation.cec_version(:tuner_2, :audio_system, "1.3a")
        assert_receive("65:9E:04")
      end
    end
  end

  describe "get_cec_version" do
    it "receives the correct code" do
      CEC.SystemInformation.get_cec_version(:tuner_2, :audio_system)
      assert_receive("65:9F")
    end
  end

  describe "get_menu_language" do
    it "receives the correct code" do
      CEC.SystemInformation.get_menu_language(:tuner_2, :audio_system)
      assert_receive("65:91")
    end
  end

  describe "give_physical_address" do
    it "receives the correct code" do
      CEC.SystemInformation.give_physical_address(:tuner_2, :audio_system)
      assert_receive("65:83")
    end
  end

  describe "polling_message" do
    it "receives the correct code" do
      CEC.SystemInformation.polling_message(:tuner_2, :audio_system)
      assert_receive("65")
    end
  end

  describe "report_physical_address" do
    it "receives the correct code" do
      CEC.SystemInformation.report_physical_address(:tuner_2, :audio_system, "3.1.0.0", :recording)
      assert_receive("65:84:31:00:01")
    end
  end

  describe "set_menu_language" do
    it "receives the correct code" do
      CEC.SystemInformation.set_menu_language(:tuner_2, :audio_system, "en")
      assert_receive("65:32:65:6E")
    end
  end
end
