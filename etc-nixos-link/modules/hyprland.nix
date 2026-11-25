{pkgs, config, ...}:
{
  # Enable Hyperland

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };
  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  hardware = {
    graphics.enable = true;
    #nvidia.modesetting.enable = true;
  };

  environment.systemPackages = [
    pkgs.waybar
    pkgs.dunst
    pkgs.libnotify
    pkgs.swaybg
    pkgs.rofi
  ];
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}