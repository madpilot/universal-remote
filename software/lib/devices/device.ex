defmodule Device do
  defmacro __using__(_opts) do
    quote do
      import Device
      @commands []
      @before_compile Device
    end
  end

  defmacro command(command, do: block) do
    quote do
      @commands [unquote(command)]
      def unquote(command)(), do: unquote(block)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def commands do
        @commands
      end
    end
  end
end
