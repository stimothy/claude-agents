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
| `--force` | Replace an existing agent file that has the same name but did not come from this repository. Without it, such files are skipped with a warning. |
| `--uninstall` | Remove the agents this repository installed. Files that did not come from it are left alone. |
| `--help` | Show usage. |

The script needs bash and works on macOS and Linux. It is safe to run more than once.

## Agents

| Agent | What it does |
|---|---|
| [`claude-whisperer`](agents/claude-whisperer.md) | Reviews the files that instruct Claude in a project (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`, skills, agent definitions, commands, hooks). Judges whether each fits its purpose, will be understood and followed, and is worth the context it costs. Read-only. |

More are on the way.

## Using an agent

Claude Code delegates to an agent on its own when a task matches the agent's description. You can also ask for one by name:

```
Use the claude-whisperer agent to audit this project's Claude setup.
```

## License

[MIT](LICENSE)
