{ pkgs, inputs, ... }:
let
  settings = import ./settings.nix { inherit pkgs; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wireguard.nix
      ./xray.nix
      ./pipewire.nix
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
    zfs.extraPools = [ "pool0" ];
    binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
  };

  networking = {
    hostName = "4eJIoBe4HoCTb"; # Define your hostname.
    hostId = "b97281ff";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    dhcpcd.wait = "background";
  };

  time.timeZone = "Asia/Yekaterinburg";


  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "colemak";
    font = "drdos8x16";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.diratof = {
    isNormalUser = true;
    extraGroups = [ "dialout" "wheel" "audio" "video" "input" "pipewire" "tty" ];     
    packages = with pkgs; [
      tmux
      bc
      cmus
      xonotic
      qemu
      # desktop
      pavucontrol
      qbittorrent
      libreoffice-fresh
      mc
      yt-dlp android-tools
      sdcv

      yacreader
      swayimg feh krita
      zathura
      mpv
      calibre
      musescore

      telegram-desktop

      (pkgs.callPackage ./packages/awesfx.nix {})
    ] ++ [ inputs.agenix.packages.${pkgs.system}.default ];
    shell = "${pkgs.tcsh}/bin/tcsh";
  };

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    htop
    unzip rar
    git
  ];
  security.rtkit.enable = true;
  services = {
    displayManager = {
      enable = true;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    dbus.enable = true;
    libinput = {
      enable = true;
      mouse.accelSpeed = "-1";
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us,ru";
        variant = "colemak,";
        options = "grp:win_space_toggle";
      };
      videoDrivers = settings.videoDrivers;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", \
        MODE:="0666", \
        SYMLINK+="stlinkv2_%n"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", \
        MODE:="0666"
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
    chrony = {
      enable = true;
      servers = [ "0.ru.pool.ntp.org" "1.ru.pool.ntp.org" "2.ru.pool.ntp.org" "3.ru.pool.ntp.org" ];
    };
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
  }; 
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
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
      extraPackages = settings.vulkanLoader;
      extraPackages32 = settings.vulkanLoader32;
    };
    bluetooth.enable = true;
    pulseaudio.enable = false;
  };
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      corefonts
      terminus_font
      comfortaa
      kbd
      (nerdfonts.override { fonts = [ "InconsolataGo" "FiraCode" "DroidSansMono" "Terminus" ]; })
    ];
    fontconfig.antialias = false;
  };
  system.stateVersion = "23.11"; # Did you read the comment?
  nixpkgs.config = { 
    allowUnfree = true;
    allowBroken = true;
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

