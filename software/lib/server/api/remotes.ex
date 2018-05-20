defmodule API.Remotes do
  def serve(%{action: :get_buses}) do
    {:reply, %{remotes: Remotes.list |> Map.keys}}
  end

  def serve(%{action: :get_remotes, bus: bus}) do
    with {:ok, module} <- Remotes.get(bus),
         {:ok, list} <- module.devices
    do
      {:reply, %{bus: bus} |> Map.merge(%{remotes: list })}
    else
      message -> message
    end
  end

  def serve(%{action: :get_keys, bus: bus, remote: remote}) do
    with {:ok, module} <- Remotes.get(bus),
         {:ok, list} <- module.commands(remote)
    do
      {:reply, %{bus: bus, remote: remote, keys: list}}
    end
  end

  def serve(%{action: :send_key, bus: bus, remote: remote, key: key}) do
    with {:ok, module} <- Remotes.get(bus),
         {:ok} <- module.send_once(remote, key)
    do
      {:ok}
    else
      message -> message
    end
  end

  def serve(%{action: :start_key, bus: bus, remote: remote, key: key}) do
    with {:ok, module} <- Remotes.get(bus),
         {:ok} <- module.send_start(remote, key)
    do
      {:ok}
    else
      message -> message
    end
  end

  def serve(%{action: :stop_key, bus: bus, remote: remote, key: key}) do
    with {:ok, module} <- Remotes.get(bus),
         {:ok} <- module.send_stop(remote, key)
    do
      {:ok}
    else
      message -> message
    end
  end

  def serve(payload) do
    {:reply, %{error: "Unknown action: #{payload[:action]}"}}
  end
end
