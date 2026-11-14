# Memlog

Working notes carried between sessions. Not part of the published agent set.

## Repo decisions (settled)

- Agent definitions live in `agents/`, one `<name>.md` per agent.
- Installer lives at `scripts/install.sh`.
  - Symlinks into `~/.claude/agents/` by default; `--copy` to copy instead.
  - `--uninstall` removes only the symlinks it created.
  - On a same-named file that isn't ours: skip and warn; `--force` overrides.
  - Idempotent; creates `~/.claude/agents/` if missing.
  - macOS and Linux (bash) only. User-level install only.
- Public repo: MIT license, README written for strangers, nothing personal in any file.
- Filenames are kebab-case and match the agent's `name` field.
- Scaffolding (script, README, license) gets written alongside the first agent.

## Review agent conventions (settled)

- Separate roster per project type, not one generalized set.
- Naming: the user wants playful names, and chose `claude-whisperer` for the first agent. Delegation runs on the `description`, so the name is free to have character. The plain domain-prefixed names listed below (`code-review-*` and so on) are placeholders to be renamed in the same spirit; no naming pattern for the whole collection has been chosen yet.
- All reviewers are read-only.
- Every agent has an explicit "not your job" section to prevent duplicate findings.
- Shared output format: location, severity, concrete description of the problem, confidence.
- Reviewers read beyond the diff (callers, surrounding code) unless the lens is blind by design.

## Code review roster (lenses settled, names proposed)

| Proposed name | Lens | Job |
|---|---|---|
| `code-review-intent` | Intent alignment | Compare what was asked for with what was built. |
| `code-review-correctness` | Correctness | Logic bugs and broken contracts with callers. Leaves boundary enumeration to edge cases. |
| `code-review-edge-cases` | Edge cases | Mechanically walk branches, boundaries and failure paths. |
| `code-review-test-gaps` | Verification gaps | Changes that could regress without any test noticing. |
| `code-review-security` | Security | Trust boundaries, injection, authorization, secrets. |
| `code-review-simplicity` | Simplicity and maintainability | Needless complexity, duplication, wrong layer. |
| `code-review-blind` | Blind hunter | Adversarial read of the diff only, with a strict severity bar. |

Optional, not yet planned: `code-review-performance` (only for projects with hot paths or databases).

## Prompt and config review roster (first draft, needs revising)

For repos like this one, where the files are instructions another model reads.
Draft lenses: prompt clarity, triggering and scope, frontmatter and structure, script safety, public-repo hygiene.
To do: rework using the method lenses (intent alignment, blind read, edge cases) as was done for the code roster.
Proposed prefix: `prompt-review-`.

## Fiction review roster (first draft, needs revising)

For novel and story-bible repos.
Draft lenses: continuity, character, structure and pacing, prose, reader experience (cold read with no story bible).
Reviewers describe problems and never rewrite prose unless asked.
To do: rework using the method lenses, as above.
Proposed prefix: `story-review-`.

## Status

- Scaffolding written: `scripts/install.sh`, `README.md`, `LICENSE`. Installer tested against a throwaway config directory and is shellcheck-clean.
- `claude-whisperer` (first called `claude-config-review`): first draft at `agents/claude-whisperer.md`, awaiting the user's review. Not yet run on real files.
  - Purpose: review the files that instruct Claude (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`, skills, agents, commands, hooks). Built first so it can review every other agent written in this repo.
  - Three questions per file: fit for purpose; understood and followed (added by the user); worth its context cost.
  - Backbone is a table of when each kind of file loads, since cost depends on load frequency.
  - Settled: one agent, not several; reviews named files or a pasted diff but always reads whole files; audits the whole setup when nothing is named; recognises files by content as well as path (this repo keeps agents in `agents/`); checks across files for duplication and contradiction; read-only (tools are Read, Grep, Glob), no web access.
  - This replaces the draft "prompt and config review roster" below as the starting point for that domain.
  - Runs on `model: opus`, `effort: high`: judgment-heavy, runs rarely on small inputs, and a wrong "cut this" is costly. Alias used instead of a full model ID so it tracks the current Opus.

- `claude-scribe`: first draft at `agents/claude-scribe.md`, awaiting the user's review. Not yet run and not yet reviewed by `claude-whisperer`. The name is my proposal; the user has not confirmed it.
  - Purpose: the writing counterpart to `claude-whisperer`. Creates and edits the same files, with the same three tests turned into rules for writing.
  - Tools: Read, Grep, Glob, Edit, Write. No Bash. `model: opus`, `effort: high`.
  - Does not set `omitClaudeMd`: it does work in the project and should follow the project's conventions. (The reviewer does set it.)
  - Never edits settings files. It describes hooks and permission rules in its report for the user to add, because hooks run commands.
  - Returns without writing when the brief does not say what behaviour is wanted, why, and when it applies.
  - Makes the smallest change; does not rewrite or delete existing instructions unless asked.
  - Open design point: the two agents each carry their own copy of the loading rules and frontmatter facts, so the copies can drift. A shared skill preloaded through the `skills` key would remove the duplication, but the installer only handles agents today. The user has a sibling repo, `claude-skills`, meant to work like this one but for skills (it held only a README on 2026-11-13). A shared skill would live there, which would make these agents depend on a second install.

## Agent file format (checked against the docs on 2026-11-13)

Source: https://code.claude.com/docs/en/sub-agents and https://code.claude.com/docs/en/model-config

- Required keys: `name`, `description`. Keys are camelCase and must match exactly.
- `effort` is a real key: `low`, `medium`, `high`, `xhigh`, `max` (levels depend on the model). Omitted, the agent uses the session's effort level. `CLAUDE_CODE_EFFORT_LEVEL` overrides it.
- `model`: `sonnet`, `opus`, `haiku`, `fable`, a full model ID, or `inherit`. Omitted, it uses the main conversation's model.
- `tools`: comma-separated string or YAML list. Omitted, the agent inherits every tool. `disallowedTools` removes tools and is applied first.
- Unrecognised keys are ignored with no error. `claude --debug` logs them ("does not recognize or apply").
- A file is skipped silently if `---` is not its first line or `name` is missing; skipped with a logged reason if `description` is missing or the YAML is invalid.
- The filename does not have to match `name`. Matching them is this repo's own convention.
- `name`: at most 256 characters, no `:`, cannot start with `-`.
- Agents load the project's `CLAUDE.md` files unless `omitClaudeMd: true`.
- Descriptions should be short: they sit in context every session.
- Other keys: `permissionMode`, `maxTurns`, `autoCompactWindow`, `skills`, `mcpServers`, `hooks`, `memory`, `background`, `isolation`, `color`, `initialPrompt`, `experimental`.
- `claude plugin validate <dir>` checks an agents directory for unparseable frontmatter.
- `omitClaudeMd: true` drops the user, project and local `CLAUDE.md` files from the agent's starting context. The docs do not say whether unscoped rules are dropped too. By default a custom agent gets `CLAUDE.md` files and project rules.
- An agent's `hooks` key can define a PreToolUse hook.

## Other file formats (checked against the docs on 2026-11-13)

Sources: https://code.claude.com/docs/en/skills, /slash-commands, /memory, /hooks, /settings

- Commands (`.claude/commands/*.md`) have been merged into skills and work the same way. They take the skill keys except `name` and `paths`. That their descriptions load every session is inferred from "work the same way", not stated.
- Skills: every key is optional; only `description` is recommended. Keys are hyphenated (`disable-model-invocation`, `allowed-tools`, `user-invocable`), except `when_to_use`. Agent keys are camelCase.
- Skill descriptions load every session; the body loads when invoked. `disable-model-invocation: true` keeps the description out of context.
- Skill `name` defaults to the directory name and need not match it.
- Unrecognised keys are ignored silently in skills, commands and rules. A skill with unparseable YAML still loads, with no fields set.
- Rules read one key, `paths` (YAML list or comma-separated string). Without it, or with broken YAML, the rule loads every session. User-level rules live in `~/.claude/rules/`.
- Hooks: plain stdout becomes context for `SessionStart`, `UserPromptSubmit`, `UserPromptExpansion` and `PostModelSwitch`. `additionalContext` adds context for those and for the tool-use, stop and subagent events. The checker read only the first third of the hooks page.
- `.claude/settings.local.json` holds personal, untracked settings; Claude Code writes permission approvals there.

## Self-review of `claude-whisperer` (2026-11-13)

First run, by an Opus subagent using the file as its own instructions, gave seven findings, all applied:

1. Reference checks now depend on where a file takes effect: here (check everything), elsewhere after install (check only what ships with it), unclear (check, report at low confidence). The user's requirement: someone who installs the agent and reviews a skill in their own repo still gets every reference checked.
2. `omitClaudeMd: true` set, so it does not take the project's `CLAUDE.md` as instructions while reviewing it.
3. Commands row corrected.
4. Hooks can cost context when they print into it.
5. Silent frontmatter failures now cover rules and skills as well as agents.
6. Bash removed from `tools`; read-only is now enforced by the tool list. Trade-off: it cannot run `git diff`, so it asks for file names when given only a commit range.
7. Audit scope: project only by default, plus `settings.local.json`; user-level files and drafts only when named.

Second pass by the same reviewer: six of the seven resolved, finding 2 partly. Four new findings and two wording points, all applied:

- Audits skip `.claude/worktrees/` (full copies of the repo), and "under `.claude/`" means at the root of the repository being worked in.
- The description now tells the delegating model to name the files or paste the diff, because the agent cannot run git.
- Project instruction files already in the agent's context (such as unscoped rules) are material to review, not instructions to it.
- Sizes are given in lines; word counts only as estimates marked "about", since the agent cannot count words.
- "Ask for the file names" became "return without reviewing and say what you need", since a subagent cannot hold a dialogue.
- Reference checks cover the project's own paths and scripts, not system tools such as `npm`.

Still untested: the agent's search behaviour in an audit (Glob and Grep were unavailable to the reviewer in the second pass), and the cost checklist, because this repo has no `CLAUDE.md`, rules or skills. Next real test: install it and run it on a repo with a full Claude setup.

Also clarified in the first round: two load points in the per-file header line, "No findings" keeps the header, replacement wording allowed within a sentence, which neighbouring files to read, conditional problems, and a second `Question` value.
- `code-review-correctness`: first draft parked at `tmp/code-review-correctness.md`, not reviewed and not installed. Shelved because the user wants to start with a different agent altogether. Reusable later as a template (section order, "not your job" list, output format, severity and confidence scales).
- Code reviewers still to write, when we return to them: `code-review-correctness` (from the parked draft), `code-review-edge-cases`, `code-review-intent`, `code-review-test-gaps`, `code-review-security`, `code-review-simplicity`, `code-review-blind`.
- `claude-whisperer` has been through two self-review rounds (see below). The user wants both agents in before merging the branch.
- Next: the user reviews the `claude-scribe` draft; have `claude-whisperer` review it; then merge, install, and try both on a repo with a real Claude setup.
- When adding an agent: add a row to the README table, and check the "not your job" lists of the existing agents still point at the right names.
- Open question: whether `tmp/memlog.md` gets pushed to the public repo or stays local.
