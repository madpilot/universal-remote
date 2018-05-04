defmodule UniversalRemote.Remotes.Behaviour do
  @callback devices :: {Atom.t, [Atom.t]}
  @callback commands(Atom.t) :: {Atom.t, [Atom.t]}
  @callback send(Atom.t, Atom.t, Atom.t) :: Atom.t
  @callback send_once(Atom.t, Atom.t) :: Atom.t
  @callback send_start(Atom.t, Atom.t) :: Atom.t
  @callback send_stop(Atom.t, Atom.t) :: Atom.t
end
