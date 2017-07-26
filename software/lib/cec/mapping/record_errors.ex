defmodule CEC.Mapping.RecordErrors do
  alias CEC.Mapping.Mapper

  def errors do
    [
      unable_to_record_digital_service: 0x05,
      unable_to_record_analogue_service: 0x06,
      unable_to_select_required_service: 0x07,
      invalid_external_plug_number: 0x09,
      invalid_external_physical_address: 0x0A,
      ca_system_not_supported: 0x0B,
      no_or_insufficent_ca_entitlements: 0x0C,
      not_allowed_to_copy_source: 0x0D,
      no_further_copies_allowed: 0x0E,
      no_media: 0x10,
      playing: 0x11,
      already_recording: 0x12,
      media_protected: 0x13,
      no_source_signal: 0x14,
      media_problem: 0x15,
      not_enough_space_available: 0x16,
      parental_lock_on: 0x17,
      terminated_normally: 0x1A,
      already_terminated: 0x1B,
      other: 0x1F
    ]
  end

  def to_code(error) do
    errors()
    |> Mapper.to_code(error)
  end

  def from_code(code) do
    errors()
    |> Mapper.from_code(code)
  end
end
