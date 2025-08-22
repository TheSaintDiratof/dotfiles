{
  inputs = {
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-25.05"; 
    };
    agenix = { 
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = { 
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ch341prog = {
      url = "github:TheSaintDiratof/ch341prog";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, agenix, nixvim, ch341prog, ... }: {
    homeConfigurations."diratof" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ 
      	nixvim.homeManagerModules.nixvim 
	      ./home 
      ];
    };
    nixosConfigurations."4eJIoBe4HoCTb" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
      ];
      specialArgs = { inherit inputs ch341prog; };
    };
  };
}
