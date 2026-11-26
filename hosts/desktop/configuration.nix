# Placeholder for a future desktop host. Not wired into flake.nix yet.
#
# To activate once you actually have the hardware:
#   1. Run `nixos-generate-config` on the desktop machine and copy the
#      generated hardware-configuration.nix into this directory.
#   2. Uncomment the `./hardware-configuration.nix` import below.
#   3. Review GPU/multi-monitor specifics (this stub deliberately skips
#      modules/system/laptop.nix -- battery/lid handling makes no sense
#      on a desktop).
#   4. Uncomment the `desktop` entry in flake.nix's nixosConfigurations.

{ ... }:

{
  imports = [
    # ./hardware-configuration.nix

    ../../modules/system/core.nix
    ../../modules/system/fonts.nix
    ../../modules/system/desktop.nix
    ../../modules/system/audio.nix
    ../../modules/system/hyprland.nix
    ../../modules/system/networking.nix
    ../../modules/system/users.nix
    ../../modules/system/dev.nix
    ../../modules/system/desktop-apps.nix
    ../../modules/system/cli-apps.nix
  ];

  networking.hostName = "nix-desktop";

  system.stateVersion = "26.05";
}
