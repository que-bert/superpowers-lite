# Installing Superpowers Lite for OpenCode

This fork keeps the OpenCode package identifier `superpowers` for
compatibility, but the git source should point at this repository.

## Prerequisites

- [OpenCode.ai](https://opencode.ai)

## Installation

Add the fork to the `plugin` array in your `opencode.json`:

```json
{
  "plugin": ["superpowers@git+https://github.com/que-bert/superpowers-lite.git"]
}
```

Restart OpenCode after updating the config.

## Verify

Ask OpenCode to list or load the bundled skills, for example:

```text
use skill tool to list skills
use skill tool to load superpowers/brainstorming
```

## Updating

OpenCode installs from the configured git source. To update, change or
pull the git ref you want to use.

Example pinned ref:

```json
{
  "plugin": ["superpowers@git+https://github.com/que-bert/superpowers-lite.git#main"]
}
```

## Troubleshooting

### Plugin not loading

1. Check the git URL in `opencode.json`.
2. Restart OpenCode after changing config.
3. Verify your OpenCode version supports git-backed plugins.

### Skills not found

1. Confirm the plugin loaded from this fork.
2. Use OpenCode's native skill tools to inspect what was discovered.
3. Check that the repo contains valid `SKILL.md` files.

Use upstream Superpowers instead if you want the original project and
its upstream documentation:

- https://github.com/obra/superpowers
