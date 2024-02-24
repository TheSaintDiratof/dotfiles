{ config, pkgs, lib, settings, ... }:
let
  colors = import ./colors.nix;
  settings = import ./settings.nix;


  myst = if settings.Xorg then (import ./xorg/st.nix { inherit pkgs colors; }).myst else {};
  dwm = if settings.Xorg then { enable = true; package = (import ./xorg/dwm.nix { inherit pkgs colors myst; }).mydwm; } else {};
  xorgPackages = if settings.Xorg then [ pkgs.feh pkgs.kbdd ] else [];
  xdgPortal = if settings.Wayland then {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  } else {};
  sway = if settings.Wayland then {
    enable = true;
    wrapperFeatures.gtk = true;
  } else {};

  videoDrivers = [ "amdgpu" ];
  vulkanLoader = pkgs.amdvlk;
  vulkanLoader32 = pkgs.driversi686Linux.amdvlk;
in
{
  networking.hostId = "b97281ff";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #(import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
      #"${nix-gaming}/modules/pipewireLowLatency.nix"
      ./wireguard.nix
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
  #home-manager.users.diratof = (import ./home.nix {inherit config pkgs lib colors Wayland myst;});
  users.users.diratof = {
    isNormalUser = true;
    extraGroups = [ "dialout" "wheel" "audio" "video" "input" "pipewire" "tty" ];     
    packages = with pkgs; [
      tmux
      bc
      cmus
      xonotic
      # desktop
      pavucontrol
      deluge
      libreoffice-fresh
      mpv
      gimp
      #(pkgs.qt6Packages.callPackage ./packages/openmv.nix {})
      # DE
    ] ++ xorgPackages;
    shell = "${pkgs.tcsh}/bin/tcsh";
  };

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    htop
    unzip
    git
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
      xkb = {
        layout = "us,ru";
        variant = "dvorak,";
        options = "grp:win_space_toggle";
      };
      displayManager.lightdm = {
        enable = true;
        greeter.enable = true;
        background = /etc/nixos/assets/wallpaper.png;
      };
      windowManager.dwm = dwm;
      libinput = {
        enable = true;
        mouse.accelSpeed = "-1";
      };
      videoDrivers = videoDrivers;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", \
        MODE:="0666", \
        SYMLINK+="stlinkv2_%n"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="abd1", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="d00d", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee7", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee4", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2b0e", ATTRS{idProduct}=="171b", \
        MODE:="0666"
    '';
  };
  xdg.portal = xdgPortal; 
  programs = {
    sway = sway;
    steam.enable = true;
  };
  security = {
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("users") && (action.id == "org.freedesktop.systemd1.manage-units"))
        {
          return polkit.Result.YES;
        }
      })
    '';
    doas.enable = false;
    sudo.enable = false;
  };
  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vulkanLoader
      ];
      extraPackages32 = with pkgs; [
        vulkanLoader32
      ];
    };
    bluetooth.enable = true;
    pulseaudio.enable = false;
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    corefonts
    terminus_font
    (nerdfonts.override { fonts = [ "InconsolataGo" "FiraCode" "DroidSansMono" "Terminus" ]; })
  ];
  system.stateVersion = "23.11"; # Did you read the comment?
  nixpkgs.config = { 
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      "curl-impersonate-0.5.4"
    ];
  };
  nix.settings = {
    sandbox = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
  zramSwap.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}

