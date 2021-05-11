{ imageTag ? null }:

with import ./nix/stackyaml.nix {};
with import ./nix/docker.nix { inherit imageTag; };

{ inherit project; inherit helloImage; }
