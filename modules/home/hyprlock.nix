{ ... }:

{
  # Installs the package only. hypr/hyprlock.conf is served via the
  # whole-directory symlink in dotfiles.nix.
  programs.hyprlock.enable = true;
}
