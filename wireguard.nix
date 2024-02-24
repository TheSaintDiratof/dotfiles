{ ... }: {
  networking.wg-quick.interfaces = {
    wg0 = builtins.fromJSON (builtins.readFile /home/diratof/.wireguard.json);
  };
}
