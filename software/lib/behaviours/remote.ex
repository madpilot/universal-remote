defmodule UniversalRemote.Remote do
  @callback devices :: [Atom.t]
  @callback commands(Atom.t) :: [Atom.t]
  @callback send_once(Atom.t, Atom.t) :: any
  @callback start_send(Atom.t, Atom.t) :: any
  @callback stop_send(Atom.t, Atom.t) :: any
end
