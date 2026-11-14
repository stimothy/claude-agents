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

### Code review

Each reviewer looks at a code change through one lens and stays out of the others, so running several together gives little duplication. All of them are read-only.

| Agent | Lens |
|---|---|
| [`code-review-correctness`](agents/code-review-correctness.md) | Logic bugs, and contracts the change breaks with the code around it. |

More are on the way.

## Using an agent

Claude Code delegates to an agent on its own when a task matches the agent's description. You can also ask for one by name:

```
Use the code-review-correctness agent to review my uncommitted changes.
```

## License

[MIT](LICENSE)
