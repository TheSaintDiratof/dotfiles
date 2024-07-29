{ config, pkgs, lib, ... }:
{
  age = {
    secrets.xray = {
      file = ./secrets/xray.age;
    };
    identityPaths = [ "/home/diratof/.ssh/id_ed25519" ];
  };

  services.xray = {
    enable = true;
    settingsFile = config.age.secrets.xray.path;
  };

  # dummy way but i don't have any other solutions
  systemd.services.xray.serviceConfig = {
    LoadCredential = "config.json:${config.age.secrets.xray.path}";
    ExecStart = lib.mkForce "${pkgs.xray}/bin/xray -c \${CREDENTIALS_DIRECTORY}/config.json";
  };
}
