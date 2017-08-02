defmodule CEC.DeckControl do
  alias CEC.Mapping.OpCodes
  alias CEC.Mapping.DeckStatus
  alias CEC.Mapping.DeckStatusRequest
  alias CEC.Mapping.DeckControl
  alias CEC.Mapping.DeckPlay

  def deck_status(source, destination, status) do
    CEC.send(source, destination, OpCodes.to_code(:deck_status), [DeckStatus.to_code(status)])
  end

  def give_deck_status(source, destination, status) do
    CEC.send(source, destination, OpCodes.to_code(:give_deck_status), [DeckStatusRequest.to_code(status)])
  end

  def deck_control(source, destination, status) do
    CEC.send(source, destination, OpCodes.to_code(:deck_control), [DeckControl.to_code(status)])
  end

  def play(source, destination, status) do
    CEC.send(source, destination, OpCodes.to_code(:play), [DeckPlay.to_code(status)])
  end
end
