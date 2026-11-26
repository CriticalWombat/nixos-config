{ config, lib, ... }:

let
  repo = "${config.home.homeDirectory}/nixos-config";
  cfg = "${config.home.homeDirectory}/.config";

  linkDir = name: ''
    ln -sfn "${repo}/${name}" "${cfg}/${name}"
  '';
in
{
  # Each of these is a whole ~/.config/<app> directory symlinked straight
  # at the matching directory in the repo -- edit files there directly
  # and reload the app, no rebuild needed. Implemented as plain `ln -sfn`
  # (not xdg.configFile) so it can never clobber the repo: `ln` only ever
  # writes to its destination argument, never its source.
  home.activation.linkRepoDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${linkDir "hypr"}
    ${linkDir "kitty"}
    ${linkDir "rofi"}
    ${linkDir "waybar"}
  '';
}
