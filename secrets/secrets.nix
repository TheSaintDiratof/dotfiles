let
  diratof = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvH1xWOQzQCWiIe37acPLM6AjpSvp5Po/B8WJfsoa/y";
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEAuihATqvNTW+6lsF4uTo0/6nK75yefek8t+FzqLt2";
  systems = [ root diratof ];
in {
  "xray.age".publicKeys = systems;
  "wireguard.age".publicKeys = systems;
}
