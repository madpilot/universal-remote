defmodule Devices.Loader.Code do
  def load_file(file) do
    Code.load_file(file)
  end

  def purge(module) do
    :code.purge(module)
  end

  def delete(module) do
    :code.delete(module)
  end
end
