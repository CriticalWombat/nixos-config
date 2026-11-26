# nixos-config

A flake-based NixOS + Hyprland desktop, themed in Catppuccin Mocha
throughout (hand-authored, no theming framework). Hyprland config,
waybar, kitty, rofi, hyprlock, and hypridle all live in this repo as
plain dotfiles -- home-manager symlinks each app's whole `~/.config/<app>`
directory straight at the matching directory here. Edit a file, reload
the app (or just re-open it), and you're done -- no rebuild needed for
any of that. Only packages and services (what's installed, what
systemd units exist) require an actual `nixos-rebuild switch`.

This repo is personalized to one machine/user (host `nix-e14`, user
`luke`) -- it is **not** a generic template yet. The steps below cover
both "just look at it in a VM" and "actually adapt it to your machine."

## Repo layout

```
flake.nix                      -- inputs (nixpkgs, home-manager) + host outputs
hosts/<name>/configuration.nix -- per-host: hostname, disks, imports
modules/system/*.nix           -- shared NixOS modules (hyprland, fonts, laptop
                                   power, desktop session, dev tools, ...)
modules/home/*.nix             -- home-manager: installs packages/services and
                                   (via dotfiles.nix) symlinks the directories
                                   below into ~/.config
hypr/      -- hyprland.lua (the whole Hyprland config), hypridle.conf,
              hyprlock.conf, cheatsheet.txt (SUPER+H reference)
waybar/    -- config, style.css
kitty/     -- kitty.conf
rofi/      -- config.rasi (app launcher), cheatsheet.rasi (SUPER+H panel)
```

Because whole directories are symlinked (not individual files), adding a
new file to one of `hypr/`, `waybar/`, `kitty/`, or `rofi/` makes it show
up at `~/.config/<app>/...` immediately -- nothing to register anywhere.

## 1. Quick look in a VM (no hardware changes needed)

The fastest way to see the desktop without touching real disks: NixOS can
build this flake straight into a throwaway QEMU VM.

```sh
git clone <this-repo-url> ~/nixos-config
cd ~/nixos-config
nix --extra-experimental-features "nix-command flakes" run \
  '.#nixosConfigurations.nix-e14.config.system.build.vm'
```

This boots a VM using the `nix-e14` host definition but with virtual
disks, ignoring the real LUKS/UUID filesystem entries in
`hosts/nix-e14/hardware-configuration.nix`. Log in as `luke` (no password
is set by default inside the VM image -- press enter), pick the Hyprland
session, and you're in. Good enough to evaluate the look/feel and test
keybinds; GPU acceleration and real hardware features (battery, wifi,
touchpad gestures) won't be meaningful inside a VM.

## 2. Adapting it to real hardware

To actually install this on a machine (yours or someone else's), you
need to replace everything that's specific to this laptop:

### a. Clone to the exact expected path

The dotfile symlinks (`modules/home/dotfiles.nix`) hardcode the repo
location as `~/nixos-config` relative to your home directory. Clone it
there:

```sh
git clone <this-repo-url> ~/nixos-config
```

### b. Generate your own hardware config

```sh
sudo nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
```

Create a new host directory (copy the pattern already scaffolded in
`hosts/desktop/`, which exists for exactly this purpose):

```sh
cp -r ~/nixos-config/hosts/desktop ~/nixos-config/hosts/<your-host-name>
cp /tmp/hardware-configuration.nix ~/nixos-config/hosts/<your-host-name>/hardware-configuration.nix
```

Edit `hosts/<your-host-name>/configuration.nix`:
- Uncomment the `./hardware-configuration.nix` import.
- Set `networking.hostName` to whatever you want.
- Remove `../../modules/system/laptop.nix` from the import list if this
  is a desktop (no battery/lid handling makes sense there) -- it's
  already left out of the `hosts/desktop` template.
- If your disk is LUKS-encrypted, add the matching
  `boot.initrd.luks.devices."<name>".device = "/dev/disk/by-uuid/<uuid>";`
  line (see `hosts/nix-e14/configuration.nix` for the pattern) -- your
  `hardware-configuration.nix` won't include this part automatically.

### c. Register the host in the flake

In `flake.nix`, uncomment and point the `desktop` line at your new host
(or add a new one the same way):

```nix
nixosConfigurations = {
  nix-e14 = mkHost ./hosts/nix-e14/configuration.nix;
  <your-host-name> = mkHost ./hosts/<your-host-name>/configuration.nix;
};
```

### d. Personalize the user

Everything currently assumes a user named `luke`:

- `modules/system/users.nix` -- change `"luke"` to your username, and
  replace the `openssh.authorizedKeys.keys` entry with your own SSH
  public key (or remove it if you don't need remote SSH access).
- `modules/home/default.nix` -- change `home.username` and
  `home.homeDirectory` to match.
- `flake.nix` -- change `home-manager.users.luke` to your username.
- `modules/system/dev.nix` -- update the `programs.git` block with your
  own name/email, and point `programs.ssh.extraConfig`'s `IdentityFile`
  at whatever SSH key you actually use for GitHub (or remove that block).
- `hypr/hyprland.lua`, `rofi/config.rasi`, `rofi/cheatsheet.rasi`,
  `waybar/config` -- a handful of commands reference
  `/home/luke/nixos-config` and `/home/luke/.config/...` as absolute
  paths rather than resolving `$HOME` (rofi's `-theme` flag, the
  hyprspace plugin load, the cheat-sheet command). `grep -rn
  /home/luke` across those four files to find every spot and swap in
  your own home directory.

Since the dotfile symlinks themselves are built from `home.homeDirectory`,
as long as you clone to `~/nixos-config` under *your* home directory and
keep the above consistent, nothing else needs to change.

### e. Install

From a NixOS installer environment, partition/format your disks, mount
them at `/mnt`, then:

```sh
sudo nixos-install --flake ~/nixos-config#<your-host-name>
```

(Or, if NixOS is already installed and you're just switching this
machine's config over: repoint `/etc/nixos` to this repo and run
`sudo nixos-rebuild switch --flake /etc/nixos#<your-host-name>`. The
installer/live ISO may need `--extra-experimental-features "nix-command
flakes"` on these commands the very first time -- after that,
`modules/system/core.nix` enables flakes permanently.)

## 3. First boot checklist

- Log in via SDDM, choose the **Hyprland** session (Plasma is still
  installed as a fallback while Hyprland matures -- see the note at the
  top of `modules/system/desktop.nix`).
- `hyprctl configerrors` should print nothing.
- Waybar and hypridle should both be running:
  `systemctl --user status waybar hypridle`.
- `hyprctl plugin list` should show Hyprspace loaded (it's loaded via
  `hyprctl plugin load` from the autostart block, not declaratively --
  see the comment in `hypr/hyprland.lua`'s PLUGINS section for why).
- Press `SUPER+H` -- a right-docked panel listing every keybind should
  slide in. That's also the fastest way to sanity-check the rest of this
  list.
- Try `SUPER+A` (launcher, left-docked), `SUPER+Tab` (workspace overview
  -- drag a window onto another workspace's panel to move it there),
  `` SUPER+` `` (scratchpad terminal, right-docked), `SUPER+L` (lock),
  `SHIFT+Print` (screenshot region).
- Click the network and volume icons on the right side of the bar --
  they should open `nm-connection-editor` and `pavucontrol`
  respectively, not just toggle mute.

## Theming notes

Everything is hand-themed in Catppuccin Mocha (mauve accent) -- there is
deliberately no theming framework (Stylix was tried and dropped: it kept
fighting the "repo is the live config" model this setup is built around).
If you want a different palette or accent, the colors are duplicated in
a few places by design, so change all of:

- `modules/home/gtk-qt.nix` -- GTK/Qt theme + cursor (`catppuccin-gtk`,
  `catppuccin-cursors` package overrides)
- `hypr/hyprland.lua` -- window border colors (`general.col`)
- `hypr/hyprlock.conf`, `hypr/hypridle.conf` -- lock screen colors
- `kitty/kitty.conf` -- terminal colors
- `rofi/config.rasi`, `rofi/cheatsheet.rasi` -- launcher/cheat-sheet
  panel colors (kept in sync with each other on purpose)
- `waybar/style.css` -- bar colors

## Gotchas worth knowing before you touch rofi or the Hyprland config

- **rofi needs `-theme <path>` passed explicitly.** Relying on rofi's
  default `~/.config/rofi/config.rasi` auto-load only picks up the
  `configuration {}` block (icon-theme, modi, etc) -- it silently
  ignores the actual widget styling (colors, window anchoring) and
  falls back to rofi's stock look. Every rofi invocation in this repo
  passes `-theme` explicitly for this reason; keep doing that for any
  new one you add.
- **Hyprland's new Lua `window_rule` wants `size`/`move` as `{expr,
  expr}` tables** (e.g. `{"monitor_w * 0.70", "monitor_h * 0.60"}`), not
  `"NN%"`-style strings -- the latter is legacy classic-syntax and
  silently no-ops under the Lua config. See `scratchpad-terminal` and
  the cheat-sheet's window rule comments in `hypr/hyprland.lua`.
- **`hl.plugin.load(...)` as a bare top-level Lua call doesn't reliably
  load a plugin on this build** (confirmed: silently no-ops on
  `hyprctl reload`). `hyprctl plugin load <path>` from the autostart
  block does, and is what's actually used.
- Nerd Font icon glyphs (waybar, kitty, hyprlock) need
  `pkgs.nerd-fonts.jetbrains-mono` actually installed
  (`modules/system/fonts.nix`) -- without it they render as nothing,
  not tofu boxes, which looks like a missing-feature bug rather than a
  missing-font one.

## Known limitations

- Single real host (`nix-e14`) today; `hosts/desktop/` is a scaffold,
  not yet activated.
- Plasma/SDDM are still installed alongside Hyprland on purpose (planned
  to be dropped once Hyprland fully covers the daily workflow).
- Hyprspace (the `SUPER+Tab` overview) has no built-in way to fullscreen
  a window from inside the overview -- only click-to-switch and
  drag-to-move-between-workspaces. Click the window, then `SUPER+F`.
- Everything is pinned to `nixos-unstable` -- expect occasional breakage
  from upstream when running `nix flake update`.
