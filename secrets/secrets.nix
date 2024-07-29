let
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvH1xWOQzQCWiIe37acPLM6AjpSvp5Po/B8WJfsoa/y";
  systems = [ nixos ];
in {
  "wireguard.age".publicKeys = systems;
  "xray.age".publicKeys = systems;
}
