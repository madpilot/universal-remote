defmodule UniversalRemote.PageController do
  use UniversalRemote.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
