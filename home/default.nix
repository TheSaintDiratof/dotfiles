{ config, pkgs, ... }:
let
  settings = import ../settings.nix {inherit pkgs; };
in { 
  imports = [ 
    (import ./qt/qt.nix {inherit pkgs settings; }) 
    (import ./gtk/gtk.nix {inherit pkgs settings; }) 
    (import ./waybar/default.nix {inherit pkgs settings; }) 
    (import ./hyprland/default.nix {inherit pkgs settings; }) 
    (import ./rofi/default.nix {inherit pkgs config settings; }) 
    (import ./dunst/default.nix {inherit settings; })
    (import ./foot/default.nix {inherit settings; })
    (import ./hypridle/default.nix {inherit pkgs; })
    (import ./obs-studio/default.nix {inherit pkgs; })
    (import ./tmux/default.nix {inherit pkgs; })
    (import ./hyprpaper/default.nix {inherit settings; })
    (import ./nixvim/default.nix {inherit settings; })
    (import ./hyprlock/default.nix {inherit settings; })
    (import ./bash/default.nix)
  ];
  home = { 
    username = "diratof";
    homeDirectory = "/home/diratof";
    sessionPath = [ "$HOME/.local/bin" ];
    stateVersion = "23.11";   
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
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
  programs.firefox.enable = true;
  programs.home-manager.enable = true;

  services.playerctld.enable = true;
}
