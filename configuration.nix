# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

#todo
#configure noise removal and rtp-sink in pipewire
#set dvorak in tty an gdm
#delete gdm and make script for login into sway from tty1
#migrate to zsh
#clean packages

{ config, pkgs, lib, ... }:


let
  unstable = import
  (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz)
  { config = config.nixpkgs.config; };
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
systemctl --user stop pipewire pipewire-pulse wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user start pipewire pipewire-pulse wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
'';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/{$schema.name}";
    in ''
export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
gnome_schema=org.gnome.desktop.interface
gsettings set $gnome_schema gtk-theme 'Dracula'
'';
  };
in
{
  networking.hostId = "b97281ff";
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./network.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-23.11.tar.gz}/nixos")
      "${nix-gaming}/modules/pipewireLowLatency.nix"
      #./pipewire.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = { 
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    #kernelParams = [ "radeon.si_support=1" "amdgpu.si_support=0" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_rt_5_15; 
    supportedFilesystems = [ "zfs" ];
  };

  networking.hostName = "4eJIoBe4HoCTb"; # Define your hostname.
  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";


  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "drdos8x16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  home-manager = { users.diratof = (import ./home.nix {inherit config pkgs lib unstable;}); };
  users.users.diratof = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "input" "pipewire" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      thunderbird
      tmux 
      cmus
      steam-run
      pavucontrol
      htop
    ];
    shell = "${pkgs.mksh}/bin/mksh";
  };

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    nixos-option
    mksh
    git
    steam
    # sway
    swaykbdd
    sway
    foot
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils
    glib
    dracula-theme
    gnome3.adwaita-icon-theme
    swayidle
    grim
    slurp
    wl-clipboard
    bemenu
    rofi
    playerctl
    pulseaudio
    conky
    deluge
    libreoffice-fresh
    # gayming
    wineWowPackages.waylandFull
  ];
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };
    };
    dbus.enable = true;
    openssh.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      libinput.enable = true;
      videoDrivers = [ "amdgpu" ];
    };
    flatpak.enable = true;
    nfs.server.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [
            vim-nix
            plenary-nvim
            nvim-treesitter
          ];
        };
        #opt.number = true;
      };
    };
    steam.enable = true;
  };
  security.doas = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      keepEnv = true;
      noPass = true;
    }];
  };
  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
          amdvlk
      ];
      # For 32 bit applications 
      # Only available on unstable
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
    bluetooth.enable = true;
    pulseaudio.enable = false;
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  nixpkgs.config = { 
    allowUnfree = true;
    allowBroken = true;
    #packageOverrides = pkgs: {
    #  Xwayland = pkgs.Xwayland.override { version = "22.1.1"; };
    #};
  };
  #nixpkgs.overlays = [ (import ./overlay.nix ) ];
  
}

