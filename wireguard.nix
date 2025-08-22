{ config, ... }: {
  age = {
    secrets.wireguard = {
      file = ./secrets/wireguard.age;
    };
    secrets.wgTV = {
      file = ./secrets/wgTV.age;
    };
    identityPaths = [ "/root/.ssh/id_ed25519" ];
  };
  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    configFile = config.age.secrets.wireguard.path;
  };
  networking.wg-quick.interfaces.wg1 = {
    autostart = true;
    configFile = config.age.secrets.wgTV.path;
  };
}
