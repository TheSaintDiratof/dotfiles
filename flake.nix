{
  inputs = {
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-24.05"; 
    };
    agenix = { 
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = { 
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, agenix, stylix, ... }: {
    homeConfigurations."diratof" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ stylix.homeManagerModules.stylix ./home.nix ];
    };
    nixosConfigurations."4eJIoBe4HoCTb" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager 
        #{
        #  home-manager = {
        #    useGlobalPkgs = true;
        #    useUserPackages = true;
        #    users.diratof = import ./home.nix;
        #    extraSpecialArgs = { inherit stylix; };
        #  };
        #}
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
