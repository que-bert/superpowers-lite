# Superpowers Lite For Codex CLI

This guide documents how this fork is intended to be used with Codex CLI.
It is fork-specific and should be read together with the root
[README](../README.md).

If you want the original project instead, use upstream Superpowers:

- https://github.com/obra/superpowers

## What Stays Compatible

This fork keeps the Codex skill-discovery path compatible with regular
Superpowers:

- the visible skills directory still lives at `~/.agents/skills/superpowers`
- Codex still discovers `SKILL.md` files natively
- no extra Codex bootstrap layer is required

The symlink name stays `superpowers` on purpose. That keeps existing
Codex setups and expectations stable even though the repo itself is
`superpowers-lite`.

## Install

### Prerequisites

- Codex CLI
- Git

### Recommended setup

1. Clone this fork:

   ```bash
   git clone https://github.com/que-bert/superpowers-lite.git ~/.codex/superpowers-lite
   ```

2. Expose the skills under the compatibility path Codex already expects:

   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/superpowers-lite/skills ~/.agents/skills/superpowers
   ```

3. Restart Codex CLI.

4. If you want subagent-oriented workflows, enable Codex multi-agent
   support:

   ```toml
   [features]
   multi_agent = true
   ```

### Windows

Use a junction if symlinks are inconvenient:

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
cmd /c mklink /J "$env:USERPROFILE\.agents\skills\superpowers" "$env:USERPROFILE\.codex\superpowers-lite\skills"
```

## How It Works

Codex CLI performs native skill discovery from `~/.agents/skills/`. This
fork relies on that behavior directly rather than adding another startup
layer on top of Codex.

The current proof bundle for this repo verifies that, for the tested
prompt suite and selected legacy baseline, the lite fork preserves the
same daily-use workflow coverage and improves the execution-path answer
for Codex CLI.

See:

- [verification/codex-cli-proof/verdict.md](/home/work/git/superpowers/verification/codex-cli-proof/verdict.md)
- [verification/codex-cli-proof/daily-use-matrix.md](/home/work/git/superpowers/verification/codex-cli-proof/daily-use-matrix.md)

## Updating

```bash
cd ~/.codex/superpowers-lite && git pull
```

The active skills update through the same symlink.

## Uninstalling

```bash
rm ~/.agents/skills/superpowers
rm -rf ~/.codex/superpowers-lite
```

Windows:

```powershell
Remove-Item "$env:USERPROFILE\.agents\skills\superpowers"
Remove-Item -Recurse -Force "$env:USERPROFILE\.codex\superpowers-lite"
```

## Troubleshooting

### Skills do not appear

1. Check the symlink or junction target.
2. Confirm the `skills/` directory exists in the cloned fork.
3. Restart Codex CLI so skill discovery runs again.

### You already have upstream installed

Either replace the existing `~/.agents/skills/superpowers` target with
this fork or keep upstream in place. Do not point the same compatibility
path at two different clones.

## Support Boundaries

This doc describes the fork's intended Codex CLI integration. The
current verification bundle proves Codex CLI behavior only; it does not
claim universal parity across every Codex host.
