defmodule Device do
  defmacro __using__(_opts) do
    quote do
      import Device

      @commands []
      @statuses []

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

  defmacro status(status, do: block) do
    quote do
      @statuses [unquote(status) | @statuses]

      def unquote(:"#{status}_status")() do
        unquote(block)
      end
    end
  end

  defmacro listen(filter, do: block) do
    quote do
      def handle_event(unquote(filter)) do
        unquote(block)
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
      use GenStage

      def start_link() do
        GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
      end

      def init(:ok) do
        case :erlang.function_exported(__MODULE__, :setup, 0) do
          false -> nil
          true -> apply(__MODULE__, :setup, [])
        end
        {:consumer, %{}, subscribe_to: [Bus]}
      end

      def handle_events(events, _from, state) do
        events
          |> Enum.each(fn(event) ->
            handle_event(event)
          end)

        {:noreply, [], state}
      end

      def commands do
        @commands
      end

      def statuses do
        @statuses
      end

      def wait(microseconds) do
        :timer.sleep(microseconds)
      end

      def wait_for(filter, do: block) do
        {:ok, pid} = Devices.OneShotListener.wait_for(filter, self())
        
        _ = block

        receive do
          {:matched, event} -> {:ok, event}
        after
          5_000 -> (
            Process.exit(pid, :normal)
            {:timeout, "Request timed out"}
          )
        end
      end

      def handle_cast({:add_filter, filter}, state) do
        {:noreply, [], [filter | state[:filters]]}
      end

      def handle_event(_) do
        nil
      end

      def set_state(key, value) do
        Devices.State.set_state(__MODULE__, key, value)
      end

      def get_state(key) do
        Devices.State.get_state(__MODULE__, key)
      end

      def get_status(status) do
        apply(__MODULE__, :"#{status}_status", [])
      end
    end
  end
end
