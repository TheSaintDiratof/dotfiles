{ ... }: {
  networking.wg-quick.interfaces = {
    wg0 = fromJSON readFile ./wireguard.json;
  };
}
