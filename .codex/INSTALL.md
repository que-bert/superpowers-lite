# Installing Superpowers Lite for Codex

Enable this fork's skills in Codex through native skill discovery.

## Why the path still says `superpowers`

Codex discovers skills from `~/.agents/skills/`. This fork keeps the
visible skill path name `superpowers` for compatibility with existing
setups and expectations, even though the repository itself is
`superpowers-lite`.

## Prerequisites

- Git

## Installation

1. **Clone this fork:**

   ```bash
   git clone https://github.com/que-bert/superpowers-lite.git ~/.codex/superpowers-lite
   ```

2. **Create the compatibility symlink:**

   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/superpowers-lite/skills ~/.agents/skills/superpowers
   ```

   **Windows (PowerShell):**

   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\superpowers" "$env:USERPROFILE\.codex\superpowers-lite\skills"
   ```

3. **Restart Codex** so it re-discovers skills.

## Verify

```bash
ls -la ~/.agents/skills/superpowers
```

You should see the compatibility path pointing at this fork's `skills/`
directory.

## Updating

```bash
cd ~/.codex/superpowers-lite && git pull
```

## Uninstalling

```bash
rm ~/.agents/skills/superpowers
rm -rf ~/.codex/superpowers-lite
```

Use upstream Superpowers instead if you want the original project and
its upstream release stream:

- https://github.com/obra/superpowers
