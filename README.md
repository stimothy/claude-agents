# claude-agents

A collection of [Claude Code subagents](https://docs.claude.com/en/docs/claude-code/sub-agents), with a script that installs them for your user account so they are available in every project.

## Install

```sh
git clone https://github.com/stimothy/claude-agents.git
cd claude-agents
scripts/install.sh
```

This symlinks every file in `agents/` into `~/.claude/agents/` (or `$CLAUDE_CONFIG_DIR/agents/` if you have set that variable). Because the files are symlinks, `git pull` updates the installed agents without a reinstall. Run the script again after a pull that adds new agents.

Restart Claude Code, or run `/agents`, to see them.

### Options

| Option | Effect |
|---|---|
| `--copy` | Copy the files instead of symlinking them. Use this if you plan to delete the clone. |
| `--force` | Replace an existing agent file that has the same name but was not installed by this script. Without it, such files are skipped with a warning. |
| `--uninstall` | Remove the agents this script installed. Files it did not install are left alone. |
| `--help` | Show usage. |

The script needs bash and works on macOS and Linux. It is safe to run more than once.

### What the script will and will not touch

The script only replaces or removes files it installed. It keeps a small manifest, `.claude-agents-manifest`, in the agents directory to remember them: for each agent, either the link it made or a checksum of the copy it made.

- A copy is still recognised after the agent changes upstream, so running `--copy` again updates it.
- A copy you have edited is treated as yours. It is skipped, not overwritten or removed, unless you pass `--force`.
- A symlink that points somewhere else is left alone, even when its target is missing.
- If you move the clone, run the script again from the new location and it repairs its own links.

The script exits with status 1 when it skipped anything, so you can tell a partial install from a complete one.

## Agents

### For the files that instruct Claude

| Agent | What it does |
|---|---|
| [`claude-whisperer`](agents/claude-whisperer.md) | Reviews the files that instruct Claude in a project (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`, skills, agent definitions, commands, hooks). Judges whether each fits its purpose, will be understood and followed, and is worth the context it costs. Read-only. |
| [`claude-wordsmith`](agents/claude-wordsmith.md) | Writes and edits those same files. Works out which kind of file an instruction belongs in, writes it so the agent reading it will follow it, and keeps it to what is worth its context. |

The two are a pair: `claude-wordsmith` writes, `claude-whisperer` reviews.

### For reviewing code

Each reviewer looks at a code change through one lens and leaves the rest to the others, so that each goes deep and their findings do not repeat. All are read-only: they report findings and never edit. A code review with no lens named goes to `code-review-sleuth`; ask for the others by name or by what they check.

| Agent | Lens | What it looks for |
|---|---|---|
| [`code-review-sleuth`](agents/code-review-sleuth.md) | Correctness | Logic bugs, and contracts broken with the unchanged callers, callees and shared state around the change. |
| [`code-review-pedant`](agents/code-review-pedant.md) | Edge cases | What happens at the boundaries and on the failure paths of each input, branch and external call. |
| [`code-review-advocate`](agents/code-review-advocate.md) | Intent | Requirements missed, misread or only partly met, and work nobody asked for. Needs the request, or to be told where it is written. |
| [`code-review-doubter`](agents/code-review-doubter.md) | Test gaps | Changed behaviour that no test would notice breaking, tests that cannot fail, and tests deleted or weakened. |
| [`code-review-locksmith`](agents/code-review-locksmith.md) | Security | Whether the change lets someone do, see or change something they should not. |
| [`code-review-minimalist`](agents/code-review-minimalist.md) | Simplicity | Needless abstraction, duplication, misplaced logic and dead code, each with the simpler version named. |
| [`code-review-skeptic`](agents/code-review-skeptic.md) | Blind read | Reads only the diff, assumes it is wrong, and reports only serious problems, each with the one thing to check. |

To run all seven on one change at once, use the `code-review-swarm` skill from [claude-skills](https://github.com/stimothy/claude-skills).

### For reviewing a novel's story bible and manuscript

A story bible is the working reference a novelist keeps for a book: its characters, world and rules, timeline, places, plot outline and style notes. Each reviewer looks at the bible, the outline or the chapters through one lens and leaves the rest to the others. All are read-only and none rewrites the author's prose: they describe problems and leave the fixing to the author. They cannot run git, so name the files or paste the text. A story-bible review with no lens named goes to `story-review-archivist`, and a chapter review with no lens named goes to `story-review-stylist`; ask for the others by name or by what they check.

| Agent | Lens | What it looks for |
|---|---|---|
| [`story-review-archivist`](agents/story-review-archivist.md) | Continuity | Contradictions between stated facts in the bible, or between a chapter and the bible. |
| [`story-review-heckler`](agents/story-review-heckler.md) | Rule implications | What the world's stated rules imply that the plot ignores or cannot survive: loopholes and "why doesn't someone just" holes. |
| [`story-review-cartographer`](agents/story-review-cartographer.md) | Coverage | What the outline needs that the bible never states, and material the story never uses. |
| [`story-review-shrink`](agents/story-review-shrink.md) | Character | Whether people's wants, fears and beliefs would make them do what the outline needs, and whether their arcs have causes. |
| [`story-review-dramaturg`](agents/story-review-dramaturg.md) | Structure | Whether events cause one another, coincidence, stakes, setup and payoff, pacing across chapters, and an earned ending. |
| [`story-review-oathkeeper`](agents/story-review-oathkeeper.md) | Intent | Whether the bible serves the book the author set out to write. Needs the statement of intent, or to be told where it is written. |
| [`story-review-stranger`](agents/story-review-stranger.md) | Cold read | Reads the outline or chapters without the bible, as a reader would, and reports what confuses, what is assumed and where interest drops. |
| [`story-review-stylist`](agents/story-review-stylist.md) | Prose | Manuscript sentences against the author's own voice: clarity, rhythm, word choice, point of view, tense. |
| [`story-review-scholar`](agents/story-review-scholar.md) | Real-world accuracy | Claims about history, science, medicine, law, geography and trades. It cannot look things up, so it separates what it is sure of from what is worth verifying. |
| [`story-review-librarian`](agents/story-review-librarian.md) | Working document | Whether a writer, or Claude drafting, can find the one current answer: organisation, repeated facts, stale entries, canon marked off from notes. |
| [`story-review-turing`](agents/story-review-turing.md) | Machine-patterned writing | Wording, constructions, punctuation, default names and stock details that make text read as AI-written. It reports patterns and makes no claim about who wrote the text. |

More are on the way.

## Using an agent

Claude Code delegates to an agent on its own when a task matches the agent's description. You can also ask for one by name:

```
Use the claude-whisperer agent to audit this project's Claude setup.
```

## Development

The installer has a test suite that needs only bash:

```sh
tests/test_install.sh
```

Each test runs the installer against a throwaway copy of the repository layout and a throwaway config directory, so your real `~/.claude` is never touched. The run also reports line coverage of `scripts/install.sh` and fails below 80%. Set `COVERAGE_MIN` to change the threshold.

The same tests run on Linux and macOS for every pull request.

## License

[MIT](LICENSE)
