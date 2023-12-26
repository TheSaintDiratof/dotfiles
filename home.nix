{ config, pkgs, lib, unstable, ... }:
#todo
#migrate to zsh
#rewrite waybar config
#use smth like pywal to generate color scheme
let
  colors = {
    ultrablack = "000000";

    brightBlack = "928374";
    brightRed = "FB4934";
    brightGreen = "B8BB26";
    brightYellow = "FABD2F";
    brightBlue = "83A598";
    brightPurple = "D3869D";
    brightAqua = "8EC07C";
    brightGray = "EBDBB2";

    black = "282828";
    red = "CC241D";
    green = "98971A";
    yellow = "D79921";
    blue = "458588";
    purple = "B16286";
    aqua = "689D6A";
    gray = "A89984";
  };
in {
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.stateVersion = "23.11";   
  nix.settings = {
  };
  programs = {
    obs-studio = import ./home/obs-studio.nix {inherit pkgs;};
    neovim = import ./home/neovim.nix {inherit pkgs;};
    #My DE
    foot = import ./home/foot.nix {inherit colors;};
    rofi = import ./home/rofi.nix {inherit colors pkgs config;};
    tmux = import ./home/tmux.nix {inherit pkgs;};
    waybar = import ./home/waybar.nix {inherit colors pkgs;};
    swaylock = import ./home/swaylock.nix {inherit colors pkgs;};
    firefox.enable = true;
  };
  services = {
    mako = import ./home/mako.nix {inherit colors;};
    swayidle = import ./home/swayidle.nix {inherit pkgs;};
  };
  wayland = {
    windowManager.sway = import ./home/sway.nix {inherit colors pkgs;};
  };
}
