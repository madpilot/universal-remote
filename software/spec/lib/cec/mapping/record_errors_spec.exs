defmodule CEC.Mapping.RecordErrorsSpec do
  use ESpec
  alias CEC.Mapping.RecordErrors

  describe "source code mappings" do
    it "maps unable_to_record_digital_service" do
      expect(RecordErrors.errors[:unable_to_record_digital_service]) |> to(eq(0x05))
    end

    it "maps unable_to_record_analogue_service" do
      expect(RecordErrors.errors[:unable_to_record_analogue_service]) |> to(eq(0x06))
    end

    it "maps unable_to_select_required_service" do
      expect(RecordErrors.errors[:unable_to_select_required_service]) |> to(eq(0x07))
    end

    it "maps invalid_external_plug_number" do
      expect(RecordErrors.errors[:invalid_external_plug_number]) |> to(eq(0x09))
    end

    it "maps invalid_external_physical_address" do
      expect(RecordErrors.errors[:invalid_external_physical_address]) |> to(eq(0x0A))
    end

    it "maps ca_system_not_supported" do
      expect(RecordErrors.errors[:ca_system_not_supported]) |> to(eq(0x0B))
    end

    it "maps no_or_insufficent_ca_entitlements" do
      expect(RecordErrors.errors[:no_or_insufficent_ca_entitlements]) |> to(eq(0x0C))
    end

    it "maps not_allowed_to_copy_source" do
      expect(RecordErrors.errors[:not_allowed_to_copy_source]) |> to(eq(0x0D))
    end

    it "maps no_further_copies_allowed" do
      expect(RecordErrors.errors[:no_further_copies_allowed]) |> to(eq(0x0E))
    end

    it "maps no_media" do
      expect(RecordErrors.errors[:no_media]) |> to(eq(0x10))
    end

    it "maps playing" do
      expect(RecordErrors.errors[:playing]) |> to(eq(0x11))
    end

    it "maps already_recording" do
      expect(RecordErrors.errors[:already_recording]) |> to(eq(0x12))
    end

    it "maps media_protected" do
      expect(RecordErrors.errors[:media_protected]) |> to(eq(0x13))
    end

    it "maps no_source_signal" do
      expect(RecordErrors.errors[:no_source_signal]) |> to(eq(0x14))
    end

    it "maps media_problem" do
      expect(RecordErrors.errors[:media_problem]) |> to(eq(0x15))
    end

    it "maps not_enough_space_available" do
      expect(RecordErrors.errors[:not_enough_space_available]) |> to(eq(0x16))
    end

    it "maps parental_lock_on" do
      expect(RecordErrors.errors[:parental_lock_on]) |> to(eq(0x17))
    end

    it "maps terminated_normally" do
      expect(RecordErrors.errors[:terminated_normally]) |> to(eq(0x1a))
    end

    it "maps already_terminated" do
      expect(RecordErrors.errors[:already_terminated]) |> to(eq(0x1b))
    end

    it "maps other" do
      expect(RecordErrors.errors[:other]) |> to(eq(0x1f))
    end
  end

  describe("to_code") do
    it "maps the source name to the relevant code" do
      expect(RecordErrors.to_code(:no_or_insufficent_ca_entitlements)) |> to(eq(0x0c))
    end
  end

  describe("from_code") do
    it "maps the code to the source name" do
      expect(RecordErrors.from_code(0x0e)) |> to(eq(:no_further_copies_allowed))
    end
  end
end
