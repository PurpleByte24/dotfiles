# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package; symlinks land in `$HOME`.

## Layout

- `common/` — shared across all machines (zsh modules, git config, `k9s`, `lazygit`, `bottom`, `fd`, misc `bin/` scripts).
- `mac/` — macOS-specific (Homebrew, Ghostty, Zed, nvim, rust/python/ruff config, Claude config, SSH config).
- `ubuntu-server/` — Ubuntu server specific (nvim, zsh, SSH config).
- `omarchy-mac/` — Hyprland/omarchy config for mac.
- `bootstrap/` — setup scripts (see below).

`stow.sh` / `unstow.sh` always link `common` plus one OS-specific package, selected by `uname -s` (Darwin → `mac`, Linux → `ubuntu-server`).

## Usage

Requires [GNU Stow](https://www.gnu.org/software/stow/) and a clean working tree. Run from the repo root:

```sh
./bootstrap/bootstrap.sh
```

This runs, in order:

1. `stow.sh` — symlinks `common` + the OS-specific package into `$HOME`.
2. `install-omz.sh` — clones Oh My Zsh.
3. `install-zsh-plugins.sh` — clones zsh plugins/theme (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`, `powerlevel10k`).
4. `change-shell-perm.sh` — sets `/bin/zsh` as the login shell.

Restart your terminal afterwards. To remove the symlinks (without undoing shell/plugin installs), run `./bootstrap/unstow.sh`.

The alias `restow` (`common/bin/automation_scripts/stow_system`) re-runs `stow -R` for `common` + the OS-specific package after pulling changes — it self-locates the repo via symlink resolution, so it only works once you've stowed at least once.
