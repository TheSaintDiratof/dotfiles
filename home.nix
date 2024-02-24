{ config, pkgs, lib, colors, myst, ... }:
let
  settings = import ./settings.nix;
  swayidle = if settings.Wayland 
  then (import ./home/swayidle.nix { inherit pkgs; })
  else {};
  waybar = if settings.Wayland
  then import ./home/waybar.nix { inherit colors pkgs; }  else {};
  swaylock = if settings.Wayland
  then import ./home/swaylock.nix { inherit colors pkgs; }  else {};
  foot = if settings.Wayland
  then import ./home/foot.nix { inherit colors; }  else {};
  sway = if settings.Wayland
  then import ./home/sway.nix { inherit colors pkgs; }  else {};

in { 
  home-manager.users.diratof = {
    home.sessionPath = [ "$HOME/.local/bin" ];
    home.stateVersion = "23.11";   
    nix.settings = {
    };
    nixpkgs.config.permittedInsecurePackages = [ "curl-impersonate-0.5.4" ];
    programs = {
      obs-studio = import ./home/obs-studio.nix {inherit pkgs;};
      neovim = import ./home/neovim.nix {inherit pkgs;};
      #My DE
      waybar = waybar;
      swaylock = swaylock;
      foot = foot;
      
      tmux = import ./home/tmux.nix {inherit pkgs;};
      rofi = import ./home/rofi.nix {inherit colors pkgs config settings myst;};
      firefox.enable = true;
    };
    services = {
      swayidle = swayidle;
      dunst = import ./home/dunst.nix {inherit colors;};
      playerctld.enable = true;
    };
    wayland = {
      windowManager.sway = sway;
    };
  };
}
