{ config, pkgs, lib, ... }:
let
  settings = import ./settings.nix {inherit pkgs; };
in { 
 
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.stateVersion = "23.11";   
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway"; 
  };

  programs = {
    obs-studio = import ./home/obs-studio.nix {inherit pkgs;};
    neovim = import ./home/neovim.nix {inherit pkgs;};
    #My DE
    waybar = import ./home/waybar.nix { inherit pkgs settings; };
    swaylock = import ./home/swaylock.nix { inherit pkgs settings; };
    foot = import ./home/foot.nix { inherit settings; };
   
    tmux = import ./home/tmux.nix {inherit pkgs;};
    rofi = import ./home/rofi.nix {inherit pkgs config settings;};
    firefox.enable = true;
  };

  services = {
    swayidle = import ./home/swayidle.nix { inherit pkgs; };
    dunst = import ./home/dunst.nix {inherit settings;};
    playerctld.enable = true;
  };

  wayland = {
    windowManager.sway = import ./home/sway.nix { inherit pkgs settings; };
  };
}
