defmodule CEC.Mapping.Mapper do
  def to_code(list, atom) do
    list[atom]
  end

  def from_code(list, code) do
    result = for atom <- list,
        fn(atom, code) -> atom
                            |> elem(1) == code
        end.(atom, code), do: atom

    case result do
      [{atom, _}] -> atom
               [] -> nil
    end
  end
end
