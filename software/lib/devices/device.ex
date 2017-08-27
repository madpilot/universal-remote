defmodule Device do
  defmacro __using__(_opts) do
    quote do
      import Device
      @commands []
      @before_compile Device
    end
  end

  defmacro command(command, allowed \\ [:send_start, :send_stop], do: block) do
    quote do
      @commands [unquote(command) | @commands]
      def unquote(command)(type) when type in unquote(allowed), do: unquote(block)
      def unquote(command)(type), do: {:ok} # Fall out the bottom
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
