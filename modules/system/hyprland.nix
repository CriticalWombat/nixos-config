{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    dunst
    libnotify
    swaybg
    rofi

    # Screenshots
    grim
    slurp
    hyprshot
    swappy

    # Clipboard history
    wl-clipboard
    cliphist

    # Network + volume dialogs for the waybar modules
    networkmanagerapplet
    pavucontrol
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
  ];
}
