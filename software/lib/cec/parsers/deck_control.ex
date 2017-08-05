defmodule CEC.Parsers.DeckControl do
  alias CEC.Mapping.{DeckControl, DeckStatus, DeckStatusRequest}

  def deck_control(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> DeckControl.from_code
    end
  end

  def deck_status(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> DeckStatus.from_code
    end
  end

  def give_deck_status(arguments) do
    case arguments do
      [code] -> code |> Integer.parse(16) |> elem(0) |> DeckStatusRequest.from_code
    end
  end
end
