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
- Names are prefixed by domain so they sort together.
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
- `claude-config-review`: first draft at `agents/claude-config-review.md`, awaiting the user's review. Not yet run on real files.
  - Purpose: review the files that instruct Claude (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`, skills, agents, commands, hooks). Built first so it can review every other agent written in this repo.
  - Three questions per file: fit for purpose; understood and followed (added by the user); worth its context cost.
  - Backbone is a table of when each kind of file loads, since cost depends on load frequency.
  - Settled: one agent, not several; reviews diffs but always reads whole files; audits the whole setup when nothing is named; recognises files by content as well as path (this repo keeps agents in `agents/`); checks across files for duplication and contradiction; read-only, no web access.
  - This replaces the draft "prompt and config review roster" below as the starting point for that domain.
- `code-review-correctness`: first draft parked at `tmp/code-review-correctness.md`, not reviewed and not installed. Shelved because the user wants to start with a different agent altogether. Reusable later as a template (section order, "not your job" list, output format, severity and confidence scales).
- Code reviewers still to write, when we return to them: `code-review-correctness` (from the parked draft), `code-review-edge-cases`, `code-review-intent`, `code-review-test-gaps`, `code-review-security`, `code-review-simplicity`, `code-review-blind`.
- Next: the user reviews the `claude-config-review` draft; then try it on this repo's own files.
- When adding an agent: add a row to the README table, and check the "not your job" lists of the existing agents still point at the right names.
- Open question: whether `tmp/memlog.md` gets pushed to the public repo or stays local.
