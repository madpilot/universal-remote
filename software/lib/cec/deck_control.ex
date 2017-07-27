defmodule CEC.DeckControl do
  alias CEC.Mapping.DeckStatus
  alias CEC.Mapping.DeckStatusRequest
  alias CEC.Mapping.DeckControl
  alias CEC.Mapping.DeckPlay

  def deck_status(source, destination, status) do
    CEC.send(source, destination, 0x1b, DeckStatus.to_code(status))
  end

  def give_deck_status(source, destination, status) do
    CEC.send(source, destination, 0x1a, DeckStatusRequest.to_code(status))
  end

  def deck_control(source, destination, status) do
    CEC.send(source, destination, 0x42, DeckControl.to_code(status))
  end

  def play(source, destination, status) do
    CEC.send(source, destination, 0x41, DeckPlay.to_code(status))
  end
end
