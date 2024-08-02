{ config, ... }: {
  age = {
    secrets.wireguard = {
      file = ./secrets/wireguard.age;
    };
    identityPaths = [ "/root/.ssh/id_ed25519" ];
  };
  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    configFile = config.age.secrets.wireguard.path;
  };
}
