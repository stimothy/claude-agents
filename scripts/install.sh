#!/usr/bin/env bash
#
# Install the agents in this repository into Claude Code's user-level agents
# directory, so they are available in every project.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/install.sh [options]

Installs every agent in agents/ into Claude Code's user-level agents
directory (~/.claude/agents, or $CLAUDE_CONFIG_DIR/agents if that is set).

By default each agent is symlinked, so edits in this repository and
"git pull" take effect without reinstalling.

Options:
  --copy        Copy the files instead of symlinking them.
  --force       Replace existing files that did not come from this repository.
  --uninstall   Remove the agents this repository installed. Files that did
                not come from this repository are left alone.
  -h, --help    Show this help.
EOF
}

mode="link"
action="install"
force=0

while [ $# -gt 0 ]; do
  case "$1" in
    --copy) mode="copy" ;;
    --force) force=1 ;;
    --uninstall) action="uninstall" ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
src_dir="$(cd "$script_dir/../agents" && pwd -P)"
dest_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/agents"

shopt -s nullglob
agents=("$src_dir"/*.md)
shopt -u nullglob

if [ ${#agents[@]} -eq 0 ]; then
  echo "No agent files found in $src_dir" >&2
  exit 1
fi

# True if anything exists at the path, including a dangling symlink.
exists() {
  [ -e "$1" ] || [ -L "$1" ]
}

# True if the destination is a symlink to the given source file.
is_our_link() {
  [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]
}

# True if the destination is a regular file identical to the source file.
is_our_copy() {
  [ -f "$2" ] && [ ! -L "$2" ] && cmp -s "$1" "$2"
}

# True if the destination is a symlink whose target no longer exists.
is_dangling() {
  [ -L "$1" ] && [ ! -e "$1" ]
}

done_count=0
skipped_count=0

install_agent() {
  local src="$1" name dest
  name="$(basename "$src")"
  dest="$dest_dir/$name"

  if [ "$mode" = "link" ] && is_our_link "$src" "$dest"; then
    echo "  ok       $name (already linked)"
    return
  fi
  if [ "$mode" = "copy" ] && is_our_copy "$src" "$dest"; then
    echo "  ok       $name (already up to date)"
    return
  fi

  if exists "$dest"; then
    if is_our_link "$src" "$dest" || is_our_copy "$src" "$dest" || is_dangling "$dest"; then
      rm -f "$dest"
    elif [ -d "$dest" ] && [ ! -L "$dest" ]; then
      echo "  skipped  $name (a directory with that name exists)" >&2
      skipped_count=$((skipped_count + 1))
      return
    elif [ "$force" -eq 1 ]; then
      rm -f "$dest"
    else
      echo "  skipped  $name (a different file exists; use --force to replace it)" >&2
      skipped_count=$((skipped_count + 1))
      return
    fi
  fi

  if [ "$mode" = "link" ]; then
    ln -s "$src" "$dest"
    echo "  linked   $name"
  else
    cp "$src" "$dest"
    echo "  copied   $name"
  fi
  done_count=$((done_count + 1))
}

uninstall_agent() {
  local src="$1" name dest
  name="$(basename "$src")"
  dest="$dest_dir/$name"

  if ! exists "$dest"; then
    return
  fi
  if is_our_link "$src" "$dest" || is_our_copy "$src" "$dest"; then
    rm -f "$dest"
    echo "  removed  $name"
    done_count=$((done_count + 1))
  else
    echo "  skipped  $name (not installed from this repository)" >&2
    skipped_count=$((skipped_count + 1))
  fi
}

if [ "$action" = "install" ]; then
  mkdir -p "$dest_dir"
  echo "Installing agents into $dest_dir"
  for src in "${agents[@]}"; do
    install_agent "$src"
  done
  echo "Installed $done_count, skipped $skipped_count."
else
  echo "Removing agents from $dest_dir"
  if [ -d "$dest_dir" ]; then
    for src in "${agents[@]}"; do
      uninstall_agent "$src"
    done
  fi
  echo "Removed $done_count, skipped $skipped_count."
fi

if [ "$skipped_count" -gt 0 ]; then
  exit 1
fi
