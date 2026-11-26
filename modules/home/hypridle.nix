{ ... }:

{
  # Installs the package + systemd user service. The config file itself
  # (hypr/hypridle.conf) is served via the whole-directory symlink in
  # dotfiles.nix, so no `settings` here -- that would make home-manager
  # also try to write the same path.
  services.hypridle.enable = true;
}
