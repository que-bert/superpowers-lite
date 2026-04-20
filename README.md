# Superpowers

Superpowers is a complete software development methodology for your coding agents, built on top of a set of composable skills and some initial instructions that make sure your agent uses them.

## How it works

It starts from the moment you fire up your coding agent. As soon as it sees that you're building something, it *doesn't* just jump into trying to write code. Instead, it steps back and asks you what you're really trying to do. 

Once it's teased a spec out of the conversation, it shows it to you in chunks short enough to actually read and digest. 

After you've signed off on the design, your agent puts together an implementation plan that's clear enough for an enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing to follow. It emphasizes true red/green TDD, YAGNI (You Aren't Gonna Need It), and DRY. 

Next up, once you say "go", it launches a *subagent-driven-development* process, having agents work through each engineering task, inspecting and reviewing their work, and continuing forward. It's not uncommon for Claude to be able to work autonomously for a couple hours at a time without deviating from the plan you put together.

There's a bunch more to it, but that's the core of the system. And because the skills trigger automatically, you don't need to do anything special. Your coding agent just has Superpowers.

Superpowers uses a compact startup router to steer the agent toward the
right workflow without injecting the full methodology into every
session. Informational requests stay light; design, implementation,
debugging, and completion work still trigger the full process.


## Sponsorship

If Superpowers has helped you do stuff that makes money and you are so inclined, I'd greatly appreciate it if you'd consider [sponsoring my opensource work](https://github.com/sponsors/obra).

Thanks! 

- Jesse


## Installation

**Note:** Installation differs by platform. 

### Claude Code Official Marketplace

Superpowers is available via the [official Claude plugin marketplace](https://claude.com/plugins/superpowers)

Install the plugin from Anthropic's official marketplace:

```bash
/plugin install superpowers@claude-plugins-official
```

### Claude Code (Superpowers Marketplace)

The Superpowers marketplace provides Superpowers and some other related plugins for Claude Code.

In Claude Code, register the marketplace first:

```bash
/plugin marketplace add obra/superpowers-marketplace
```

Then install the plugin from this marketplace:

```bash
/plugin install superpowers@superpowers-marketplace
```

### OpenAI Codex CLI

- Open plugin search interface

```bash
/plugins
```

Search for Superpowers

```bash
superpowers
```

Select `Install Plugin`

### OpenAI Codex App

- In the Codex app, click on Plugins in the sidebar.
- You should see `Superpowers` in the Coding section. 
- Click the `+` next to Superpowers and follow the prompts.


### Cursor (via Plugin Marketplace)

In Cursor Agent chat, install from marketplace:

```text
/add-plugin superpowers
```

or search for "superpowers" in the plugin marketplace.

### OpenCode

Tell OpenCode:

```
Fetch and follow instructions from https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.opencode/INSTALL.md
```

**Detailed docs:** [docs/README.opencode.md](docs/README.opencode.md)

### GitHub Copilot CLI

```bash
copilot plugin marketplace add obra/superpowers-marketplace
copilot plugin install superpowers@superpowers-marketplace
```

### Gemini CLI

```bash
gemini extensions install https://github.com/obra/superpowers
```

To update:

```bash
gemini extensions update superpowers
```

## The Basic Workflow

Superpowers-lite keeps a small default routed path and leaves the rest available for explicit or manual use.

### Core Routed Skills

These are the skills the compact router steers toward for action-oriented work:

- **brainstorming** - Turn a request into an approved spec before implementation.
- **using-git-worktrees** - Default isolation step after spec approval and before planning or execution.
- **writing-plans** - Convert an approved spec into an executable implementation plan.
- **subagent-driven-development** - Default execution path for approved plans.
- **systematic-debugging** - Default debugging workflow before any fix is proposed.
- **requesting-code-review** - Review major implementation work before it compounds.
- **verification-before-completion** - Verify before claiming anything is done or fixed.
- **receiving-code-review** - Evaluate review feedback rigorously before implementing it.

### Support Skills (manual or explicit use)

These remain available, but they are not part of the default hot path:

- **executing-plans** - Fallback when the user explicitly wants inline execution.
- **dispatching-parallel-agents** - Explicit parallelization tool for truly independent work.
- **finishing-a-development-branch** - Completion workflow for merge, PR, keep, or discard decisions.
- **test-driven-development** - Strict test-first discipline used inside implementation workflows.
- **writing-skills** - Skill authoring and verification workflow.
- **using-superpowers** - Reference guidance on how the system fits together.

**The agent checks for relevant workflows before action-oriented tasks.**
Informational turns stay light until they become design or implementation work.

## What's Inside

- **Compact startup router** - Small SessionStart guidance for action-oriented work.
- **Core routed workflow skills** - The default design, planning, execution, debugging, review, and verification path.
- **Support skills** - Optional isolation, inline execution, TDD, branch completion, and skill-authoring workflows.
- **Manual skill access** - The full skill library remains available for explicit invocation.

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success

Read [the original release announcement](https://blog.fsck.com/2025/10/09/superpowers/).

## Contributing

The general contribution process for Superpowers is below. Keep in mind that we don't generally accept contributions of new skills and that any updates to skills must work across all of the coding agents we support.

1. Fork the repository
2. Switch to the 'dev' branch
3. Create a branch for your work
4. Follow the `writing-skills` skill for creating and testing new and modified skills
5. Submit a PR, being sure to fill in the pull request template.

See `skills/writing-skills/SKILL.md` for the complete guide.

## Updating

Superpowers updates are somewhat coding-agent dependent, but are often automatic.

## License

MIT License - see LICENSE file for details

## Community

Superpowers is built by [Jesse Vincent](https://blog.fsck.com) and the rest of the folks at [Prime Radiant](https://primeradiant.com).

- **Discord**: [Join us](https://discord.gg/35wsABTejz) for community support, questions, and sharing what you're building with Superpowers
- **Issues**: https://github.com/obra/superpowers/issues
- **Release announcements**: [Sign up](https://primeradiant.com/superpowers/) to get notified about new versions
