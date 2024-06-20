{
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-24.05"; };
    home-manager = { 
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations."4eJIoBe4HoCTb" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager 
        {

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.diratof = import ./home.nix;
          };
        }
      ];
    };
  };
}
