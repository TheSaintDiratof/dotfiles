{ pkgs, config, ... }:
let
  settings = import ../settings.nix {inherit pkgs; };
in { 
  imports = [ 
    (import ./qt/qt.nix               {inherit pkgs settings;       }) 
    (import ./gtk/gtk.nix             {inherit pkgs settings;       }) 

    (import ./waybar/default.nix      {inherit pkgs settings;       }) 
    #(import ./hyprland/default.nix    {inherit pkgs settings;       }) 
    #(import ./hypridle/default.nix    {inherit pkgs;                })
    #(import ./hyprpaper/default.nix   {inherit      settings;       })
    #(import ./hyprlock/default.nix    {inherit      settings;       })
    (import ./sway/sway.nix           {inherit pkgs settings;       })
    (import ./sway/swaylock.nix       {inherit pkgs settings;       })
    (import ./sway/swayidle.nix       {inherit pkgs;                })
    (import ./foot/default.nix        {inherit      settings;       })
  
    #(import ./bspwm/bspwm.nix         {inherit pkgs;                })
    #(import ./bspwm/sxhkd.nix         {inherit pkgs settings;       })
    #(import ./urxvt/default.nix       {inherit pkgs settings;       })

    (import ./rofi/default.nix        {inherit pkgs settings config;}) 
    (import ./dunst/default.nix       {inherit      settings;       })
    (import ./obs-studio/default.nix  {inherit pkgs;                })
    (import ./tmux/default.nix        {inherit pkgs;                })
    (import ./nixvim/default.nix      {inherit pkgs settings;       })
    (import ./bash/default.nix)
  ];
  home = { 
    username = "diratof";
    homeDirectory = "/home/diratof";
    sessionPath = [ "$HOME/.local/bin" ];
    stateVersion = "23.11";   
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "hyprland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      EDITOR = "nvim";
    };
    pointerCursor = {
      name = "Vimix-cursors";
      package = pkgs.vimix-cursors;
      size = 32;
      x11.enable = true;
      gtk.enable = true;
    };
    packages = [
      pkgs.qt6Packages.qtstyleplugin-kvantum
    ];
  };
  programs.firefox.enable = true;
  programs.home-manager.enable = true;

  services.playerctld.enable = true;
}
