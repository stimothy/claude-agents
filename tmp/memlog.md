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
  - Settled: one agent, not several; reviews diffs but always reads whole files; audits the whole setup when nothing is named; recognises files by content as well as path (this repo keeps agents in `agents/`); checks across files for duplication and contradiction; read-only, no web access.
  - This replaces the draft "prompt and config review roster" below as the starting point for that domain.
  - Runs on `model: opus`, `effort: high`: judgment-heavy, runs rarely on small inputs, and a wrong "cut this" is costly. Alias used instead of a full model ID so it tracks the current Opus.

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
- `code-review-correctness`: first draft parked at `tmp/code-review-correctness.md`, not reviewed and not installed. Shelved because the user wants to start with a different agent altogether. Reusable later as a template (section order, "not your job" list, output format, severity and confidence scales).
- Code reviewers still to write, when we return to them: `code-review-correctness` (from the parked draft), `code-review-edge-cases`, `code-review-intent`, `code-review-test-gaps`, `code-review-security`, `code-review-simplicity`, `code-review-blind`.
- Next: the user reviews the `claude-whisperer` draft; then try it on this repo's own files.
- When adding an agent: add a row to the README table, and check the "not your job" lists of the existing agents still point at the right names.
- Open question: whether `tmp/memlog.md` gets pushed to the public repo or stays local.
