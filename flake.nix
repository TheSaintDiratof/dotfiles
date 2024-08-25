{
  inputs = {
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-24.05"; 
    };
    agenix = { 
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = { 
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, agenix, nixvim, ... }: {
    homeConfigurations."diratof" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ 
      	nixvim.homeManagerModules.nixvim 
	      ./home 
      ];
    };
    nixosConfigurations."MbIcJIuTeJIb" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
