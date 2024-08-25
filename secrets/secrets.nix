let
  diratof = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Em1t4H64VO48MCsR7R/nNHjhiipOYDl2zwwuyMqEN diratof@MbIcJIuTeJIb";
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5CnCRb6XWDC96m9ZrY+smK4ICLhFB1okV+ijxA9jVw root@MbIcJIuTeJIb";
  systems = [ root diratof ];
in {
  "xray.age".publicKeys = systems;
  "wireguard.age".publicKeys = systems;
}
