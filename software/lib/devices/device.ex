defmodule Device do
  defmacro __using__(_opts) do
    quote do
      import Device
      @commands []
      @before_compile Device
    end
  end

  defmacro on_send_start(do: block) do
    quote do
      [send_start: fn() -> unquote(block) end]
    end
  end

  defmacro on_send_stop(do: block) do
    quote do
      [send_stop: fn() -> unquote(block) end]
    end
  end

  defmacro on_send_once(do: block) do
    quote do
      [send_once: fn() -> unquote(block) end]
    end
  end

  defmacro command(command, do: block) do
    # We split the lines, and convert each into it's own block that is referenced
    # by it's own key.
    #
    # If there is only one command, just use the block
    blocks = case block do
      {:__block__ , [], command_blocks} -> command_blocks
        |> Enum.map(fn(block) -> {:__block__, [], [block]} end)
      _ -> [block]
    end

    quote do
      @commands [unquote(command) | @commands]

      def unquote(command)(type) do
        case unquote(blocks) |> List.flatten |> Keyword.fetch(type) do
          {:ok, fun} -> fun.()
          :error -> nil
        end
      end
    end
  end

  defmacro passthrough(commands, [to: module, device: device]) do
    commands
    |> Enum.map(fn(command) ->
      quote do
        @commands [unquote(command) | @commands]
        def unquote(command)(type) do
          case type do
            :send_start -> unquote(module).send_start(unquote(device), unquote(command))
            :send_stop -> unquote(module).send_stop(unquote(device), unquote(command))
            :send_once -> unquote(module).send_once(unquote(device), unquote(command))
          end
        end
      end
    end)
  end

  defmacro passthrough(commands, [to: device]) do
    commands
    |> Enum.map(fn(command) ->
      quote do
        @commands [unquote(command) | @commands]
        def unquote(command)(type) do
          case type do
            :send_start -> unquote(device).send_start(unquote(command))
            :send_stop -> unquote(device).send_stop(unquote(command))
            :send_once -> unquote(device).send_once(unquote(command))
          end
        end
      end
    end)
  end

  defmacro __before_compile__(_env) do
    quote do
      def commands do
        @commands
      end

      def wait(microseconds) do
        :timer.sleep(microseconds)
      end
    end
  end
end
