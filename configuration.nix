{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Memory / Swap
  zramSwap.enable = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };


  # Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Keyboard
  console.keyMap = "de";

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Audio
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Fingerprint reader
  services.fprintd.enable = true;


  # This laptop also serves: it hosts a writing app that other people reach
  # over a tunnel. Closing the lid on mains power therefore leaves it running
  # rather than suspending, since suspending takes the app offline and, with a
  # Cloudflare quick tunnel, loses the public address for good. On battery it
  # still suspends, because a bag is no place to hold a server.
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  # Android development. programs.adb was removed from nixpkgs: systemd 258
  # applies the uaccess rules itself, so a phone over USB no longer needs a
  # group or udev rules of its own - only the tools.
  environment.systemPackages = [ pkgs.android-tools ];

  # User
  users.users.i = {
    isNormalUser = true;
    description = "I";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    # Start this user's services at boot instead of waiting for someone to log
    # in, and keep them running after logout. Without this the writing app
    # comes back only once a person sits down at the machine.
    linger = true;
  };

  # Do not change this just because NixOS is upgraded.
  system.stateVersion = "26.05";
}
