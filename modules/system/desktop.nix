{ ... }:

{
  # Kept around as a fallback session while the Hyprland setup matures.
  # End goal is to drop Plasma/SDDM entirely once Hyprland fully covers
  # the daily workflow (lock screen, portals, screen sharing, etc).
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
