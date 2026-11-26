{ pkgs, ... }:

{
  # hypr/hyprland.lua is served via the whole-directory symlink set up in
  # dotfiles.nix (~/.config/hypr -> repo/hypr) -- nothing to manage here
  # for the file itself.

  # The plugin .so lives in the Nix store and its path changes on every
  # update, so this one *is* store-managed. Because ~/.config/hypr is a
  # symlink to the repo, this physically lands at repo/hypr/plugins/ too
  # (gitignored) -- that's fine, it's a store symlink, not real content.
  xdg.configFile."hypr/plugins/hyprspace.so".source =
    "${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so";
}
