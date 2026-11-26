{ ... }:

{
  # Installs the package + systemd user service. config/style.css are
  # served via the whole-directory symlink in dotfiles.nix.
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
}
