# Memlog

Working notes carried between sessions. Not part of the published agent set.

## Repo decisions (settled)

- Agent definitions live in `agents/`, one `<name>.md` per agent.
- Installer lives at `scripts/install.sh`.
  - Symlinks into `~/.claude/agents/` by default; `--copy` to copy instead.
  - `--uninstall` removes only what it installed.
  - On a same-named file that isn't ours: skip and warn; `--force` overrides.
  - Ownership is tracked in a manifest (see "Installer changes after PR review").
  - Idempotent; creates `~/.claude/agents/` if missing.
  - macOS and Linux (bash) only. User-level install only.
- Public repo: MIT license, README written for strangers, nothing personal in any file.
- Filenames are kebab-case and match the agent's `name` field.
- Scaffolding (script, README, license) gets written alongside the first agent.

## Installer changes after PR review (2026-11-14)

PR #1 got two automated review comments (Codex), both on `scripts/install.sh`, both fixed:

- A `--copy` install lost its identity once the source changed, because ownership was judged by comparing against the current source. The script now keeps a manifest, `.claude-agents-manifest`, in the agents directory: file name, `link` or `copy`, and the link target or the copy's checksum (`cksum`).
- A dangling symlink was replaced without `--force` even when it belonged to another installation. Dangling links are now protected like any other file; the script's own dangling links (after the repository moves) are recognised through the manifest.
- A copy the user has edited no longer matches its recorded checksum, so it is treated as theirs: skipped on install, left on uninstall.

Tests: `tests/test_install.sh`, plain bash with no dependencies (bats and kcov are not installed locally). 32 tests. Coverage is line coverage measured from `bash -x` output, with executable lines picked out by an awk heuristic; the run fails below `COVERAGE_MIN` (default 80). CI in `.github/workflows/test.yml` runs it on Linux and macOS.

Known gap, not fixed: when an agent is renamed or removed in the repository, its old link stays in the agents directory. The manifest would allow pruning these.

## Review agent conventions (settled)

- Separate roster per project type, not one generalized set.
- Naming: the user wants playful names, and chose `claude-whisperer` for the first agent and `claude-wordsmith` for its writing partner. Delegation runs on the `description`, so the name is free to have character. The plain domain-prefixed names listed below (`code-review-*` and so on) are placeholders to be renamed in the same spirit; no naming pattern for the whole collection has been chosen yet.
- All reviewers are read-only.
- Every agent has an explicit "not your job" section to prevent duplicate findings.
- Shared output format: location, severity, concrete description of the problem, confidence.
- Reviewers read beyond the diff (callers, surrounding code) unless the lens is blind by design.

## Code review roster (lenses settled)

Naming pattern, chosen by the user on 2026-11-14: `code-review-<character noun>`. The prefix groups the roster and says what each agent is; the last word carries the character. All seven are written under these names (PR #2).

| Name | Status | Lens | Job |
|---|---|---|---|
| `code-review-sleuth` | settled, written | Correctness | Logic bugs and broken contracts with callers. Leaves boundary enumeration to edge cases. |
| `code-review-advocate` | written | Intent alignment | Compare what was asked for with what was built. Speaks for the request. |
| `code-review-pedant` | written | Edge cases | Mechanically walk branches, boundaries and failure paths. |
| `code-review-doubter` | written | Verification gaps | Changes that could regress without any test noticing. |
| `code-review-locksmith` | written | Security | Trust boundaries, injection, authorization, secrets. |
| `code-review-minimalist` | written | Simplicity and maintainability | Needless complexity, duplication, wrong layer. |
| `code-review-skeptic` | written | Blind hunter | Adversarial read of the diff only, with a strict severity bar. |

Optional, not yet planned and not yet named: a performance reviewer (only for projects with hot paths or databases).

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

## Story-review roster (written 2026-11-15, reviewed, review not applied)

Replaces the "Fiction review roster" draft above. Eleven agents under `agents/story-review-*.md`, for a novel's story bible and manuscript. The user is starting a novel and will build its bible with Claude.

| Name | Lens |
|---|---|
| `story-review-archivist` | Continuity. Takes a story-bible review that names no lens. The template for the rest. |
| `story-review-heckler` | Rule implications ("then why doesn't someone just...?") |
| `story-review-cartographer` | Coverage: what the plot needs that is unstated, and unused material |
| `story-review-shrink` | Character |
| `story-review-dramaturg` | Structure |
| `story-review-oathkeeper` | Fit to the author's stated intent |
| `story-review-stranger` | Cold read with no bible (`tools: Read, Glob`, `omitClaudeMd: true`) |
| `story-review-stylist` | Prose |
| `story-review-scholar` | Real-world accuracy, no web access |
| `story-review-librarian` | The bible as a working document (`sonnet`; the rest are `opus`) |
| `story-review-turing` | Machine-patterned writing, which the user calls AI-isms. Added at the user's request. |

- Names were proposed in the session and the user said to build them; `turing` was not separately confirmed.
- All are read-only by tool list (no Bash), so the caller names files or pastes text. They describe problems and never rewrite.
- Method: the archivist was written by `claude-wordsmith`, reviewed by `claude-whisperer`, fixed, and signed off by the user. The other ten were then written in parallel from it with one shared brief, and reviewed in parallel: ten individual reviews plus one of the set.
- The AI-isms checklist in the turing came from a web research pass; the condensed notes are in `tmp/ai-isms-research.md`.
- State: the archivist's first-round fixes are applied. Nothing from the second round is applied. The findings are in `tmp/story-review-findings/` (one file per agent, `roster.md` for the set, `README.md` for counts and the cross-file decisions). Eight high findings in all. The user ran out of time and asked for the review to be saved.
- Next: settle the cross-file decisions in `tmp/story-review-findings/README.md`, then one `claude-wordsmith` run per file with its findings file plus one shared text for the decisions, then a set review. After that, add the roster to the README's agent tables.
- The user plans skills later that show when to use one story reviewer over another. None exist yet.
- Raised by the reviews, outside the agents: a per-roster install option, since the eleven descriptions add about 690 words to every session for every user of the repository.

## Status

- Scaffolding written: `scripts/install.sh`, `README.md`, `LICENSE`. Installer tested against a throwaway config directory and is shellcheck-clean.
- `claude-whisperer` (first called `claude-config-review`): first draft at `agents/claude-whisperer.md`, awaiting the user's review. Not yet run on real files.
  - Purpose: review the files that instruct Claude (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`, skills, agents, commands, hooks). Built first so it can review every other agent written in this repo.
  - Three questions per file: fit for purpose; understood and followed (added by the user); worth its context cost.
  - Backbone is a table of when each kind of file loads, since cost depends on load frequency.
  - Settled: one agent, not several; reviews named files or a pasted diff but always reads whole files; audits the whole setup when nothing is named; recognises files by content as well as path (this repo keeps agents in `agents/`); checks across files for duplication and contradiction; read-only (tools are Read, Grep, Glob), no web access.
  - This replaces the draft "prompt and config review roster" below as the starting point for that domain.
  - Runs on `model: opus`, `effort: high`: judgment-heavy, runs rarely on small inputs, and a wrong "cut this" is costly. Alias used instead of a full model ID so it tracks the current Opus.

- `claude-wordsmith` (first called `claude-scribe`; the user chose the name): at `agents/claude-wordsmith.md`. Not yet run for real.
  - Purpose: the writing counterpart to `claude-whisperer`. Creates and edits the same files, with the same three tests turned into rules for writing.
  - Tools: Read, Grep, Glob, Edit, Write. No Bash. `model: opus`, `effort: high`.
  - Sets `omitClaudeMd: true`, like the reviewer. (First draft left it off so the agent would follow project conventions; the review pointed out it reads the root `CLAUDE.md` itself anyway, so the default load paid for it twice and went stale after an edit.)
  - Reviewed once, by a fresh Opus subagent using `claude-whisperer` as its instructions. Three findings, all applied: descriptions it writes must say when not to use the thing; the frontmatter key lists are marked as examples, with the missing skill keys added; `omitClaudeMd: true`.
  - That review also showed four gaps in `claude-whisperer`, all applied: "elsewhere" includes user-level installs; wrong or incomplete Claude Code facts in a file are findings; files read only for context get no header line; it checks whether a `model` or `effort` setting fits the job.
  - Paired review of both files (third review round overall), six findings, all applied. On the wordsmith: point to files with a plain path, not an `@path` import; on an unresolved conflict, do not write the new text; a hook's printed output costs context; name suspected dead keys in the report; frontmatter must be valid YAML, so quote descriptions containing a colon and a space. On the whisperer: skip `.claude/worktrees/` only inside the repository under review, since the agent may itself be running in a worktree. Also: the header's line count is for the whole file.
  - Fourth round (paired, no worktree hint in the brief): two findings, both on the wordsmith and both in text added the round before, all applied. The YAML quoting rule moved to the general frontmatter paragraph and widened (`: `, ` #`, leading special characters); "leave existing keys as they are" narrowed to "do not remove or rename a key because you do not recognise it". Two clarifications to the whisperer: a missing "when not to use" is a finding only where a request would be misrouted; user-level descriptions load in every project.
  - The whisperer's worktree wording held up without help in round four. Findings per round ran 7, 4, 3, 6, 2, and the later ones were corrections to earlier patches, so more stand-in rounds are unlikely to pay. A real installed run is the next test.
  - Reviewing the two as a pair caught disagreements between them that single-file reviews missed. Worth repeating whenever either changes.
  - In all three stand-in trials since the first, Grep and Glob were unavailable to the reviewer (Read only), so the agents' file-finding is still unexercised.
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
- `code-review-sleuth` (first called `code-review-correctness`; the user chose the name): written to `agents/code-review-sleuth.md` on 2026-11-14 by the installed `claude-wordsmith` (its first real run), from the parked draft at `tmp/code-review-correctness.md`. Not yet reviewed by `claude-whisperer`, not yet run, not committed.
  - `tools: Read, Grep, Glob, Bash`, `model: opus`, `effort: high`. Bash is needed for `git diff`, so read-only is held by instruction, not by the tool list. If cost per run is a problem, lower `effort` to `medium` and keep Opus.
  - `omitClaudeMd` left at the default: a project's `CLAUDE.md` is evidence of what the code is meant to do. The body tells it to ignore build, test and edit instructions found there.
  - Written to be correct when installed alone: the other lenses are described as out of scope, with no `code-review-*` names, since none of those agents exists.
  - Additions over the draft: untracked files are included in "uncommitted changes"; steps per kind of target (pasted diff, range or branch, pull request, named files); how to work out what the change is trying to do; what to prioritise on a change too large to trace.
  - Open: it may run `gh pr diff` (network, changes nothing) for a pull request with no local branch.
  - Reviewed by the installed `claude-whisperer` on 2026-11-14 (its first real run; Grep and Glob worked). Four findings. Three applied by `claude-wordsmith`: a revision that is not checked out is read with `git show <rev>:<path>` and searched with `git grep <pattern> <rev>`, and a `gh pr diff` is treated as a pasted diff; named files with no change are reviewed whole, and the pre-existing-problems exclusion does not apply to them; a serious out-of-lens problem noticed in passing gets one line at the end under `Noticed in passing, not investigated:`, because no sibling reviewer exists to catch it. Not yet re-reviewed after those edits.
  - Fourth finding, not applied: read-only Bash is held only by prose. Checked against the docs (sub-agents, hooks) on 2026-11-15: `tools` takes bare tool names only; a pattern in `disallowedTools`, such as `Bash(git push *)`, "still removes the whole tool". Options that remain: a `PreToolUse` hook in the agent's `hooks` key (gets the command as JSON on stdin, blocks with exit code 2; the docs' example uses a script file, which the installer does not ship, and an inline one-liner is untested), or `permissionMode: plan` (unconfirmed whether `git diff` still runs under it). Left as prose until the agent has had real runs.
  - Template for the remaining reviewers: section order, "not your job" list, output format, severity and confidence scales.
- The other six code reviewers were written on 2026-11-15, each by its own `claude-wordsmith` run, with the sleuth as template: `code-review-pedant`, `code-review-advocate`, `code-review-doubter`, `code-review-locksmith`, `code-review-minimalist`, `code-review-skeptic`. The user confirmed the names by asking for them to be written. Uncommitted, and not yet reviewed.
  - Models: `sonnet` at `high` for the pedant and doubter (methodical work, tried on the cheaper model; the user chose this for the pedant); `opus` at `high` for the rest.
  - The shared skeleton (read-only rules, finding the change, output format) is copied into each file, not shared through a skill. The user chose copying for now; revisit once it is clear what is truly common.
  - Routing: a code review with no lens named goes to the sleuth; every other description claims only requests that name its lens.
  - Advocate: needs a statement of what was asked for and returns without reviewing if it finds none. Its output carries a numbered requirements list before the findings, and each finding has a `Kind` (missing, misread, partial, unrequested). May run `gh pr view` and `gh issue view`.
  - Doubter: never runs tests; for each changed behaviour it names a breakage and reasons from the test code whether any test would fail.
  - Locksmith: defensive only; works out who can reach the code before treating input as attacker-controlled; reports a found secret's location and type, not its value. Finding fields are Attacker, Path, Gain.
  - Minimalist: a finding must name the simpler version; three severity levels, not four; judges against the codebase's own conventions.
  - Skeptic: `tools: Read, Bash` and `omitClaudeMd: true` so the tool list helps hold the blindness; `git diff -U20`; critical and high only; no `Noticed in passing` section.
  - Notes the writers raised on the sleuth's shared skeleton, to settle in the roster review and then apply to all seven files: `git status` hides files inside new untracked directories unless `--untracked-files=all`; `git symbolic-ref refs/remotes/origin/HEAD` returns a full ref while the next step uses a bare branch name; for a pull request with no local branch, reading touched files "as they stand" reads the wrong revision; "These belong to other lenses" assumes siblings exist; `gh pr diff` is used but not listed among the allowed commands; `git diff HEAD` fails in a repository with no commits.
- Review round on the roster (2026-11-15): eight `claude-whisperer` runs, one per file plus one on the seven as a set. About 54 per-file findings and 13 set findings, two of them high (the locksmith's description claimed any change "touching" input handling and so competed with the sleuth; untracked files inside new directories were missed). The user said to apply everything. Applied by seven `claude-wordsmith` runs, one per file, all reading one corrected shared text so the copies match. Not yet re-reviewed.
  - Shared text now in every file ("Finding the change" is identical across six files apart from the lens sentence; the skeptic has an adapted version): default branch found once with `git symbolic-ref --short`; a pasted diff is checked for whether it is applied; a pull request is taken by its head commit from `gh pr view --json headRefName,baseRefName,headRefOid`, falling back to `gh pr diff`, never by a possibly stale local branch name; after `gh pr diff` the working tree is used only for unchanged surrounding code; "uncommitted changes" is a nameable target that stops on a clean tree; named files are decided per file (untracked, uncommitted edits, changed on the branch, or unchanged); untracked files come from `git status --untracked-files=all`, skipping generated, vendored, binary and very large files; a repository with no commits is handled.
  - Descriptions: the six lens-specific ones were cut to about 50 words each (lens, triggers that name the lens, pointer to the sleuth, target sentence, "Read-only"). The sleuth keeps the full target list and the exclusion of Claude instruction files and prose, because it is the catch-all. Total across the seven went from about 590 words to about 400.
  - Boundaries settled: sleuth reports a boundary or failure-path problem only on a path it was already tracing, the pedant sweeps them; a crash an outside caller can trigger is reported by the pedant as a crash and judged as denial of service by the locksmith; user-visible unrequested features and options are the advocate's, internal generality is the minimalist's; the doubter's example breakages include "moving a boundary by one" so untested boundaries are caught.
  - Per file: pedant got cases for branches, arithmetic and dates, and always walks in priority order; advocate's requirements list carries a status per line, the linked issue outranks the pull request description, and it has a misread-versus-buggy test; doubter's "no tests" case is a statement and not a finding, repeated gaps are grouped, severity is by damage; locksmith never repeats a secret's value, separates committed from uncommitted secrets, states its assumed deployment, and does not run audit tools; minimalist counts uses through framework signatures, registration and test code before calling anything unused; skeptic claims only "blind, cold or diff-only" requests and may run only the `--json` form of `gh pr view`.
  - Final set review after the fixes: 11 findings, none high, all applied directly. The parallel edits held up (references resolve, shared sections agree). Fixed: locksmith trigger "safe" became "secure" so it does not claim "is this safe to merge?"; the advocate claims only "does it meet the request", and a review that merely mentions a ticket is the sleuth's; the minimalist's description excludes Claude instruction files and it no longer rates a public option (the advocate's ground); the sleuth owns error handling the change writes or alters and anything on a path it was tracing, not sweeps; the doubter's "no tests" statement has one condition (no test exercises any of the changed code in an area); the pedant's triggers include "error-handling"; the advocate does not use the current branch's pull request for uncommitted edits; the skeptic may run `git rev-parse --verify`; the locksmith rates a takedown by an ordinary account as medium.
  - Findings per round on the roster ran about 67, then 11, with the later ones mostly in text the earlier round added. Stopped reviewing there; real runs on code changes are the next test. None of the seven has been run on real code yet.
  - PR #2 got two automated review comments (Codex, 2026-11-15), both valid, both on the shared text, fixed in `af3eca4` in the six non-blind reviewers:
    - The pull request path checked only the head commit and diffed against `origin/<baseRefName>`, which may be missing or stale. It now asks for `baseRefOid` too, diffs `<baseRefOid>...<headRefOid>`, and takes the local path only when both commits exist; otherwise `gh pr diff`.
    - A committed target that is checked out could be read from a working tree holding uncommitted edits, so an uncommitted fix or test could hide a problem. The working tree is now read only when the target's last commit is `HEAD` and `git status --short` prints nothing; otherwise `git show` and `git grep`.
  - `claude-whisperer` review of that fix (one run, given the old and new sentences): the three sentences are identical across the six files and close both comments for branches, ranges and pull requests. Seven findings, none high. 1 to 6 applied; 7 skipped on purpose (narrow case, and it would add a command to a file kept deliberately tight). The applied wording has not been reviewed again:
    1. Medium: the `gh pr diff` fallback now also happens when the head commit is local and only the base is missing, but "Stay read-only" still says the working tree does not hold that version. Read files at the head commit when it exists.
    2. Medium: "How to review" reads the old version at `<base>`, which is undefined for a pull request and, for a three-dot diff, should be the merge base, not the base tip (sleuth, locksmith, doubter, pedant). Partly older than this fix.
    3. Medium: named files whose change is already committed are not in the new sentence's list of committed targets, so uncommitted callers or tests can still be read as the change.
    4. Medium: advocate step 2 says "reading the code as it stands", which means the working tree.
    5. Low to medium: the branch bullet tests "the branch is checked out" (a name), where "Stay read-only" tests the commit; a branch checked out in another worktree would pass the first and fail the second.
    6. Low: minimalist's "not only the working tree" pulls against the new rule.
    7. Low, optional: the skeptic can still diff against a stale base when the caller names a local branch for a pull request.
  - Judged not worth fixing: "These belong to other lenses" (accurate now that the seven ship together); `gh` commands missing from an allowed list that says "such as".
  - Method worth repeating: per-file reviews found most of the problems, and the same shared-text faults surfaced in every one, which is what made a single corrected text the right fix. The set review found the routing and boundary problems the per-file reviews could not see.
- README: the agents section is now two tables, one for the Claude-file pair and one for the code reviewers.
- `claude-whisperer` has been through two self-review rounds (see below). The user wants both agents in before merging the branch.
- Next: merge the branch, install, and try both agents on a repo with a real Claude setup.
- When adding an agent: add a row to the README table, and check the "not your job" lists of the existing agents still point at the right names.
- Open question: whether `tmp/memlog.md` gets pushed to the public repo or stays local.
