defmodule Test4iz210Web.PageController do
  use Test4iz210Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
