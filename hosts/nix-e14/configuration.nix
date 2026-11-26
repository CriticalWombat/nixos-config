# Host-specific configuration for nix-e14 (ThinkPad-class laptop).
# Shared behavior lives in ../../modules/system/*; this file should only
# contain things unique to this physical machine.

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./custom-hardware.nix

    ../../modules/system/core.nix
    ../../modules/system/fonts.nix
    ../../modules/system/desktop.nix
    ../../modules/system/audio.nix
    ../../modules/system/hyprland.nix
    ../../modules/system/laptop.nix
    ../../modules/system/networking.nix
    ../../modules/system/users.nix
    ../../modules/system/dev.nix
    ../../modules/system/desktop-apps.nix
    ../../modules/system/cli-apps.nix
  ];

  boot.initrd.luks.devices."luks-e0661ba1-29b3-4bba-b71f-84d453bf6c84".device =
    "/dev/disk/by-uuid/e0661ba1-29b3-4bba-b71f-84d453bf6c84";

  networking.hostName = "nix-e14";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Do NOT change this value unless you have manually inspected all the changes it would make to your
  # configuration, and migrated your data accordingly.
  system.stateVersion = "26.05";
}
