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

| Agent | What it does |
|---|---|
| [`claude-whisperer`](agents/claude-whisperer.md) | Reviews the files that instruct Claude in a project (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`, skills, agent definitions, commands, hooks). Judges whether each fits its purpose, will be understood and followed, and is worth the context it costs. Read-only. |
| [`claude-wordsmith`](agents/claude-wordsmith.md) | Writes and edits those same files. Works out which kind of file an instruction belongs in, writes it so the agent reading it will follow it, and keeps it to what is worth its context. |

The two are a pair: `claude-wordsmith` writes, `claude-whisperer` reviews.

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
