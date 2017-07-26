defmodule CEC.Mapping.Sources do
  def sources do
    [
      currently_selected: 0x1,
      digital: 0x2,
      analogue: 0x3,
      external: 0x4
    ]
  end

  def source_to_code(source) do
    sources()[source]
  end

  def code_to_source(code) do
    result = for source <- sources(),
        fn(source, code) -> source
                            |> elem(1) == code
        end.(source, code), do: source

    case result do
      [{source, _}] -> source
            [] -> nil
    end
  end
end
