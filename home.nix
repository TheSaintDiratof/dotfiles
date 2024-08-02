{ config, pkgs, lib, ... }:
let
  settings = import ./settings.nix {inherit pkgs config; };
in { 
  imports = [ 
    (import ./home/qt/qt.nix {inherit pkgs settings; }) 
    (import ./home/gtk/gtk.nix {inherit pkgs settings; }) 
  ];
  home = { 
    username = "diratof";
    homeDirectory = "/home/diratof";
    sessionPath = [ "$HOME/.local/bin" ];
    stateVersion = "23.11";   
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "qt5ct";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      EDITOR = "nvim";
    };
    pointerCursor = {
      name = "Vimix-cursors";
      package = pkgs.vimix-cursors;
      size = 14;
      x11.enable = true;
      gtk.enable = true;
    };
  };

  programs = {
    obs-studio = import ./home/obs-studio.nix {inherit pkgs;};
    nixvim = import ./home/nixvim.nix {inherit settings;};
    #My DE
    waybar = import ./home/waybar.nix { inherit pkgs settings; };
    hyprlock = import ./home/hyprlock.nix { inherit settings; };
    foot = import ./home/foot.nix { inherit settings; };
   
    tmux = import ./home/tmux.nix {inherit pkgs;};
    rofi = import ./home/rofi.nix {inherit pkgs config settings;};
    firefox.enable = true;
    home-manager.enable = true;
  };

  services = {
    hypridle = import ./home/hypridle.nix { inherit pkgs; }; 
    dunst = import ./home/dunst.nix {inherit settings;};
    hyprpaper = import ./home/hyprpaper.nix {inherit settings; };
    playerctld.enable = true;
  };

  wayland.windowManager.hyprland = import ./home/hyprland.nix { inherit pkgs settings; };
}
