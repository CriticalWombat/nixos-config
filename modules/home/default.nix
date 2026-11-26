{ ... }:

{
  home.username = "luke";
  home.homeDirectory = "/home/luke";

  # Matches system.stateVersion in hosts/*/configuration.nix. Do not bump
  # casually -- see the home-manager release notes before changing this.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  imports = [
    ./dotfiles.nix
    ./hyprland.nix
    ./waybar.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./gtk-qt.nix
  ];
}
