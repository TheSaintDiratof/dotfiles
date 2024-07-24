let
  pidor = builtins.fromJSON (builtins.readFile /etc/wireguard.json);
  roskomhuylo = builtins.fromJSON (builtins.readFile (builtins.fetchurl "https://reestr.rublacklist.net/api/v3/ips"));
  f = x: (if (builtins.match "^.*[:](.+)[:].*$" x  == null) then false else true);
in
{ lib, ... }: {
  networking.wg-quick.interfaces.wg0 = {
    address = pidor.address;
    dns = pidor.dns;
    privateKey = pidor.privateKey;
    peers = [ 
      { 
        publicKey = pidor.peer.publicKey; 
        endpoint = pidor.peer.endpoint;
        #allowedIPs = [ "0.0.0.0/0" "::/0" ];
        allowedIPs = [ "104.21.234.103" "172.67.70.99" "104.21.32.39" "188.114.99.224" "104.27.207.92"] 
        ++ [ "35.186.224.24" ]
        ++ [ "188.114.98.224"]
        ++ ["172.64.146.15" "172.64.152.228" "172.64.150.28" "104.18.35.28" ]; # openai
        #++ [ "149.154.167.99" ]; # telegram
        #allowedIPs = builtins.filter f roskomhuylo;
      }
    ];
  };
}
