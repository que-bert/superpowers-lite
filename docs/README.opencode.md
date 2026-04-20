# Superpowers Lite For OpenCode

This guide documents the OpenCode installation and behavior expected by
this fork. It replaces the inherited upstream wording with repo-specific
notes while keeping the compatibility details that matter.

If you want the original project instead, use upstream Superpowers:

- https://github.com/obra/superpowers

## Compatibility Notes

This fork keeps the package name `superpowers` in `package.json` for
plugin compatibility. That means OpenCode install strings still begin
with `superpowers@...` even when the git source is this fork.

## Installation

Add the fork to the `plugin` array in `opencode.json`:

```json
{
  "plugin": ["superpowers@git+https://github.com/que-bert/superpowers-lite.git"]
}
```

Restart OpenCode after changing the config.

## What This Fork Preserves

- OpenCode can still discover the same skill set through the plugin
- the plugin entry name remains `superpowers` for compatibility
- the repo keeps the same general workflow vocabulary as upstream

## What This Fork Changes

- the docs are fork-specific instead of inherited upstream copy
- the repository identity is `superpowers-lite`
- verification emphasis currently centers on lite routing and Codex CLI,
  not a broad claim that every host has already been re-proven end to end

## Updating

OpenCode installs from the configured git source. To update, pull or pin
the git source you want OpenCode to use.

Example pinned reference:

```json
{
  "plugin": ["superpowers@git+https://github.com/que-bert/superpowers-lite.git#main"]
}
```

## How It Works

The plugin keeps the same broad integration shape:

1. It registers the repo's skills with OpenCode.
2. It supplies the fork's bootstrap or routing context where supported by
   the host.
3. It lets OpenCode's native tools handle the actual editing and
   execution.

## Personal And Project Skills

You can still add your own OpenCode skills separately:

- personal skills in `~/.config/opencode/skills/`
- project skills in `.opencode/skills/`

Those remain distinct from the fork's bundled skills.

## Troubleshooting

### Plugin not loading

1. Verify the git URL in `opencode.json`.
2. Confirm OpenCode can install plugins from git in your environment.
3. Restart OpenCode after config changes.

### Skills not found

1. Use OpenCode's native skill listing tools.
2. Confirm the plugin actually loaded from this fork.
3. Check that the repo contains valid `SKILL.md` files.

### You previously installed upstream

If OpenCode is still pulling `obra/superpowers`, replace the source URL
with this fork explicitly. Otherwise you are still on upstream.
