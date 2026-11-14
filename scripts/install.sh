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
  --force       Replace existing files that this script did not install.
  --uninstall   Remove the agents this script installed. Files it did not
                install, or that were edited after a --copy install, are
                left alone.
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

# The manifest records what this script installed: one line per agent, holding
# its file name, "link" or "copy", and the link target or the copy's checksum.
# It lets the script recognise its own files after the source has changed or
# the repository has moved, without mistaking anyone else's files for its own.
manifest="$dest_dir/.claude-agents-manifest"
tab="$(printf '\t')"

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

checksum() {
  cksum <"$1"
}

# Prints the manifest entry for a file name as "kind<TAB>value", or nothing.
recorded() {
  if [ -f "$manifest" ]; then
    awk -F'\t' -v name="$1" '$1 == name { print $2 "\t" $3 }' "$manifest"
  fi
}

# Removes a file name from the manifest, and the manifest once it is empty.
forget() {
  if [ -f "$manifest" ]; then
    awk -F'\t' -v name="$1" '$1 != name' "$manifest" >"$manifest.tmp"
    mv "$manifest.tmp" "$manifest"
    if [ ! -s "$manifest" ]; then
      rm -f "$manifest"
    fi
  fi
}

# Records a file name in the manifest with its kind and value.
record() {
  forget "$1"
  printf '%s\t%s\t%s\n' "$1" "$2" "$3" >>"$manifest"
}

# True if the destination is something this script installed and nobody has
# changed since: a link to the source, a link the manifest recorded, a copy
# identical to the source, or a copy whose checksum the manifest recorded.
is_ours() {
  local src="$1" dest="$2" name="$3" entry kind value target
  entry="$(recorded "$name")"
  kind="${entry%%"$tab"*}"
  value="${entry#*"$tab"}"

  if [ -L "$dest" ]; then
    target="$(readlink "$dest")"
    if [ "$target" = "$src" ]; then
      return 0
    fi
    if [ "$kind" = "link" ] && [ "$target" = "$value" ]; then
      return 0
    fi
    return 1
  fi

  if [ -f "$dest" ]; then
    if cmp -s "$src" "$dest"; then
      return 0
    fi
    if [ "$kind" = "copy" ] && [ "$(checksum "$dest")" = "$value" ]; then
      return 0
    fi
  fi
  return 1
}

done_count=0
skipped_count=0

skip() {
  echo "  skipped  $1 ($2)" >&2
  skipped_count=$((skipped_count + 1))
}

install_agent() {
  local src="$1" name dest
  name="$(basename "$src")"
  dest="$dest_dir/$name"

  if [ "$mode" = "link" ] && [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    record "$name" link "$src"
    echo "  ok       $name (already linked)"
    return 0
  fi
  if [ "$mode" = "copy" ] && [ -f "$dest" ] && [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then
    record "$name" copy "$(checksum "$dest")"
    echo "  ok       $name (already up to date)"
    return 0
  fi

  if exists "$dest"; then
    if [ -d "$dest" ] && [ ! -L "$dest" ]; then
      skip "$name" "a directory with that name exists"
      return 0
    fi
    if [ "$force" -eq 0 ] && ! is_ours "$src" "$dest" "$name"; then
      skip "$name" "a file this script did not install exists; use --force to replace it"
      return 0
    fi
    rm -f "$dest"
  fi

  if [ "$mode" = "link" ]; then
    ln -s "$src" "$dest"
    record "$name" link "$src"
    echo "  linked   $name"
  else
    cp "$src" "$dest"
    record "$name" copy "$(checksum "$dest")"
    echo "  copied   $name"
  fi
  done_count=$((done_count + 1))
}

uninstall_agent() {
  local src="$1" name dest
  name="$(basename "$src")"
  dest="$dest_dir/$name"

  if ! exists "$dest"; then
    forget "$name"
    return 0
  fi
  if is_ours "$src" "$dest" "$name"; then
    rm -f "$dest"
    forget "$name"
    echo "  removed  $name"
    done_count=$((done_count + 1))
  else
    skip "$name" "not installed by this script, or changed since"
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
