{ config, pkgs, lib, ... }:
let
  unstable = 
  import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz")
  { config = config.nixpkgs.config; };
  nix-gaming = 
  import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in
{
  networking.hostId = "b97281ff";
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-23.11.tar.gz}/nixos")
      "${nix-gaming}/modules/pipewireLowLatency.nix"
    ];

  # Use the systemd-boot EFI boot loader.
  boot = { 
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_rt_5_15; 
    supportedFilesystems = [ "zfs" ];
  };

  networking.hostName = "4eJIoBe4HoCTb"; # Define your hostname.
  time.timeZone = "Asia/Yekaterinburg";


  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
    font = "drdos8x16";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  home-manager.users.diratof = (import ./home.nix {inherit config pkgs lib unstable;});
  users.users.diratof = {
    isNormalUser = true;
    extraGroups = [ "dialout" "wheel" "audio" "video" "input" "pipewire" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tmux 
      cmus
      xonotic
      # desktop
      pavucontrol
      deluge
      libreoffice-fresh
      mpv
      gimp
      (pkgs.qt6Packages.callPackage ./packages/openmv.nix {})
    ];
    shell = "${pkgs.mksh}/bin/mksh";
  };

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    htop
  ];
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
    dbus.enable = true;
    xserver = {
      enable = true;
      layout = "us,ru";
      xkbVariant = "dvorak,";
      xkbOptions = "grp:win_space_toggle";
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      libinput.enable = true;
      videoDrivers = [ "amdgpu" ];
    };
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", \
        MODE:="0666", \
        SYMLINK+="stlinkv2_%n"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="abd1", \
        MODE:="0666"
    '';
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
    steam.enable = true;
  };
  security = {
    doas.enable = false;
    sudo.enable = false;
  };
  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
          amdvlk
      ];
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
  system.stateVersion = "23.11"; # Did you read the comment?
  nixpkgs.config = { 
    allowUnfree = true;
    allowBroken = true;
  };
  zramSwap.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}

