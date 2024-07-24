{ config, pkgs, lib, ... }:
let
  settings = import ./settings.nix {inherit pkgs; };
in { 
 
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.stateVersion = "23.11";   
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    QT_QPA_PLATFORM = "wayland";
  };

  programs = {
    obs-studio = import ./home/obs-studio.nix {inherit pkgs;};
    neovim = import ./home/neovim.nix {inherit pkgs;};
    #My DE
    waybar = import ./home/waybar.nix { inherit pkgs settings; };
    hyprlock = import ./home/hyprlock.nix { inherit settings; };
    foot = import ./home/foot.nix { inherit settings; };
   
    tmux = import ./home/tmux.nix {inherit pkgs;};
    rofi = import ./home/rofi.nix {inherit pkgs config settings;};
    firefox.enable = true;
  };

  services = {
    hypridle = import ./home/hypridle.nix { inherit pkgs; }; 
    dunst = import ./home/dunst.nix {inherit settings;};
    hyprpaper = import ./home/hyprpaper.nix {inherit settings; };
    playerctld.enable = true;
  };

  wayland = {
    windowManager = { 
      hyprland = import ./home/hyprland.nix { inherit pkgs settings; };
    };
  };
  gtk = { 
    enable = true;
    theme.name = "Nordic-bluish-accent-standard-buttons";
  };
  qt = { 
    enable = true;
    platformTheme.name = "gtk";
  };
}
