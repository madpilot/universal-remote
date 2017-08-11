defmodule UniversalRemote.Remotes.Behaviour do
  @callback devices :: {Atom.t, [Atom.t]}
  @callback commands(Atom.t) :: {Atom.t, [Atom.t]}
  @callback send_once(Atom.t, Atom.t) :: Atom.t
  @callback start_send(Atom.t, Atom.t) :: Atom.t
  @callback stop_send(Atom.t, Atom.t) :: Atom.t
end
