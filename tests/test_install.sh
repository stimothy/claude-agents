#!/usr/bin/env bash
#
# Tests for scripts/install.sh, with a line-coverage check.
#
# Needs only bash and the standard Unix tools. Each test builds a throwaway
# copy of the repository layout and a throwaway config directory, so nothing
# touches the real ~/.claude.
#
# Usage: tests/test_install.sh
#   COVERAGE_MIN=80   Minimum line coverage, in percent (default 80).

set -u

# The tests choose the config directory themselves. Clearing this keeps a
# value from the caller's environment from pointing a test at a real one.
unset CLAUDE_CONFIG_DIR

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
script="$repo_root/scripts/install.sh"
coverage_min="${COVERAGE_MIN:-80}"

scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
trace="$scratch/trace"
: >"$trace"

tests_run=0
tests_failed=0
current_test=""
current_failed=0

# Set by each test's setup.
work=""
fixture=""
config=""
dest=""
manifest=""

# Set by run_install.
out=""
err=""
status=0

# --- Harness -----------------------------------------------------------------

setup() {
  work="$(mktemp -d "$scratch/test.XXXXXX")"
  work="$(cd "$work" && pwd -P)"
  fixture="$work/repo"
  config="$work/config"
  dest="$config/agents"
  manifest="$dest/.claude-agents-manifest"
  mkdir -p "$fixture/scripts" "$fixture/agents"
  cp "$script" "$fixture/scripts/install.sh"
  printf 'alpha agent\n' >"$fixture/agents/alpha.md"
  printf 'beta agent\n' >"$fixture/agents/beta.md"
}

# Runs the installer from a repository layout with the given arguments.
# The script runs under xtrace so the lines it executes can be counted;
# the trace is split off from the script's own stderr.
run_in() {
  local root="$1" raw="$work/stderr.raw"
  shift
  out="$(PS4='+COV:${LINENO}: ' bash -x "$root/scripts/install.sh" "$@" 2>"$raw")"
  status=$?
  grep -E '^\++COV:[0-9]+: ' "$raw" >>"$trace"
  err="$(grep -vE '^\++COV:[0-9]+: ' "$raw")"
}

run_install() {
  CLAUDE_CONFIG_DIR="$config" run_in "$fixture" "$@"
}

fail() {
  if [ "$current_failed" -eq 0 ]; then
    echo "FAIL  $current_test"
  fi
  echo "        $1"
  current_failed=1
}

assert_status() {
  if [ "$status" -ne "$1" ]; then
    fail "expected exit status $1, got $status (stdout: $out) (stderr: $err)"
  fi
}

assert_contains() {
  case "$1" in
    *"$2"*) ;;
    *) fail "expected to find \"$2\" in: $1" ;;
  esac
}

assert_link_to() {
  if [ ! -L "$1" ]; then
    fail "expected a symlink at $1"
  elif [ "$(readlink "$1")" != "$2" ]; then
    fail "expected $1 to link to $2, got $(readlink "$1")"
  fi
}

assert_regular_file() {
  if [ -L "$1" ] || [ ! -f "$1" ]; then
    fail "expected a regular file at $1"
  fi
}

assert_content() {
  if [ "$(cat "$1" 2>/dev/null)" != "$2" ]; then
    fail "expected $1 to contain \"$2\", got \"$(cat "$1" 2>/dev/null)\""
  fi
}

assert_absent() {
  if [ -e "$1" ] || [ -L "$1" ]; then
    fail "expected nothing at $1"
  fi
}

run_test() {
  current_test="$1"
  current_failed=0
  tests_run=$((tests_run + 1))
  setup
  "$1"
  if [ "$current_failed" -eq 0 ]; then
    echo "ok    $1"
  else
    tests_failed=$((tests_failed + 1))
  fi
}

# --- Installing with symlinks ------------------------------------------------

test_link_install_creates_symlinks() {
  run_install
  assert_status 0
  assert_link_to "$dest/alpha.md" "$fixture/agents/alpha.md"
  assert_link_to "$dest/beta.md" "$fixture/agents/beta.md"
  assert_contains "$out" "linked   alpha.md"
  assert_contains "$out" "Installed 2, skipped 0."
}

test_link_install_is_idempotent() {
  run_install
  run_install
  assert_status 0
  assert_contains "$out" "ok       alpha.md (already linked)"
  assert_contains "$out" "Installed 0, skipped 0."
  assert_link_to "$dest/alpha.md" "$fixture/agents/alpha.md"
}

test_installs_into_home_when_config_dir_is_unset() {
  local home="$work/home"
  mkdir -p "$home"
  HOME="$home" run_in "$fixture"
  assert_status 0
  assert_link_to "$home/.claude/agents/alpha.md" "$fixture/agents/alpha.md"
}

test_creates_the_destination_directory() {
  assert_absent "$dest"
  run_install
  assert_status 0
  if [ ! -d "$dest" ]; then
    fail "expected $dest to be created"
  fi
}

test_handles_a_file_name_with_a_space() {
  printf 'spaced agent\n' >"$fixture/agents/two words.md"
  run_install
  assert_status 0
  assert_link_to "$dest/two words.md" "$fixture/agents/two words.md"
  run_install --uninstall
  assert_status 0
  assert_absent "$dest/two words.md"
}

test_ignores_files_that_are_not_markdown() {
  printf 'notes\n' >"$fixture/agents/notes.txt"
  run_install
  assert_status 0
  assert_absent "$dest/notes.txt"
}

# --- Installing with copies --------------------------------------------------

test_copy_install_creates_regular_files() {
  run_install --copy
  assert_status 0
  assert_regular_file "$dest/alpha.md"
  assert_content "$dest/alpha.md" "alpha agent"
  assert_contains "$out" "copied   alpha.md"
}

test_copy_install_is_idempotent() {
  run_install --copy
  run_install --copy
  assert_status 0
  assert_contains "$out" "ok       alpha.md (already up to date)"
  assert_contains "$out" "Installed 0, skipped 0."
}

test_switching_from_link_to_copy_and_back() {
  run_install
  run_install --copy
  assert_status 0
  assert_regular_file "$dest/alpha.md"
  run_install
  assert_status 0
  assert_link_to "$dest/alpha.md" "$fixture/agents/alpha.md"
}

# A copy must stay recognisable as ours after the source changes, so that an
# update replaces it and an uninstall removes it.
test_copy_is_updated_after_the_source_changes() {
  run_install --copy
  printf 'alpha agent, version two\n' >"$fixture/agents/alpha.md"
  run_install --copy
  assert_status 0
  assert_contains "$out" "copied   alpha.md"
  assert_content "$dest/alpha.md" "alpha agent, version two"
}

test_copy_is_uninstalled_after_the_source_changes() {
  run_install --copy
  printf 'alpha agent, version two\n' >"$fixture/agents/alpha.md"
  run_install --uninstall
  assert_status 0
  assert_absent "$dest/alpha.md"
  assert_absent "$dest/beta.md"
}

# A copy the user has edited is theirs now, and is protected like any other
# file the script did not install.
test_edited_copy_is_not_overwritten() {
  run_install --copy
  printf 'my own edits\n' >"$dest/alpha.md"
  printf 'alpha agent, version two\n' >"$fixture/agents/alpha.md"
  run_install --copy
  assert_status 1
  assert_contains "$err" "skipped  alpha.md"
  assert_content "$dest/alpha.md" "my own edits"
}

test_edited_copy_is_not_uninstalled() {
  run_install --copy
  printf 'my own edits\n' >"$dest/alpha.md"
  run_install --uninstall
  assert_status 1
  assert_contains "$err" "skipped  alpha.md (not installed by this script, or changed since)"
  assert_content "$dest/alpha.md" "my own edits"
  assert_absent "$dest/beta.md"
}

# --- Files the script did not install ----------------------------------------

test_foreign_file_is_skipped() {
  mkdir -p "$dest"
  printf 'someone else\n' >"$dest/alpha.md"
  run_install
  assert_status 1
  assert_contains "$err" "skipped  alpha.md"
  assert_contains "$err" "--force"
  assert_content "$dest/alpha.md" "someone else"
  assert_link_to "$dest/beta.md" "$fixture/agents/beta.md"
  assert_contains "$out" "Installed 1, skipped 1."
}

test_force_replaces_a_foreign_file() {
  mkdir -p "$dest"
  printf 'someone else\n' >"$dest/alpha.md"
  run_install --force
  assert_status 0
  assert_link_to "$dest/alpha.md" "$fixture/agents/alpha.md"
}

test_foreign_symlink_is_skipped() {
  mkdir -p "$dest"
  printf 'someone else\n' >"$work/other.md"
  ln -s "$work/other.md" "$dest/alpha.md"
  run_install
  assert_status 1
  assert_link_to "$dest/alpha.md" "$work/other.md"
}

# A dangling symlink that belongs to another installation must survive, for
# example a link into a checkout that is temporarily unavailable.
test_foreign_dangling_symlink_is_skipped() {
  mkdir -p "$dest"
  ln -s "$work/missing/alpha.md" "$dest/alpha.md"
  run_install
  assert_status 1
  assert_contains "$err" "skipped  alpha.md"
  assert_link_to "$dest/alpha.md" "$work/missing/alpha.md"
}

test_force_replaces_a_foreign_dangling_symlink() {
  mkdir -p "$dest"
  ln -s "$work/missing/alpha.md" "$dest/alpha.md"
  run_install --force
  assert_status 0
  assert_link_to "$dest/alpha.md" "$fixture/agents/alpha.md"
}

test_foreign_dangling_symlink_is_not_uninstalled() {
  mkdir -p "$dest"
  ln -s "$work/missing/alpha.md" "$dest/alpha.md"
  run_install --uninstall
  assert_status 1
  assert_link_to "$dest/alpha.md" "$work/missing/alpha.md"
}

# Our own link goes dangling when the repository moves. The manifest lets the
# script recognise it and repair it without --force.
test_own_dangling_symlink_is_repaired_after_the_repository_moves() {
  run_install
  mv "$fixture" "$work/moved"
  CLAUDE_CONFIG_DIR="$config" run_in "$work/moved"
  assert_status 0
  assert_contains "$out" "linked   alpha.md"
  assert_link_to "$dest/alpha.md" "$work/moved/agents/alpha.md"
}

test_directory_with_the_same_name_is_skipped_even_with_force() {
  mkdir -p "$dest/alpha.md"
  run_install --force
  assert_status 1
  assert_contains "$err" "a directory with that name exists"
  if [ ! -d "$dest/alpha.md" ]; then
    fail "expected the directory to survive"
  fi
}

# --- Uninstalling ------------------------------------------------------------

test_uninstall_removes_links() {
  run_install
  run_install --uninstall
  assert_status 0
  assert_contains "$out" "removed  alpha.md"
  assert_contains "$out" "Removed 2, skipped 0."
  assert_absent "$dest/alpha.md"
  assert_absent "$dest/beta.md"
}

test_uninstall_removes_copies() {
  run_install --copy
  run_install --uninstall
  assert_status 0
  assert_absent "$dest/alpha.md"
}

test_uninstall_leaves_foreign_files() {
  mkdir -p "$dest"
  printf 'someone else\n' >"$dest/alpha.md"
  run_install --uninstall
  assert_status 1
  assert_content "$dest/alpha.md" "someone else"
}

test_uninstall_with_nothing_installed() {
  mkdir -p "$dest"
  run_install --uninstall
  assert_status 0
  assert_contains "$out" "Removed 0, skipped 0."
}

test_uninstall_without_a_destination_directory() {
  run_install --uninstall
  assert_status 0
  assert_absent "$dest"
}

# --- The manifest ------------------------------------------------------------

test_manifest_records_installs_and_is_removed_on_uninstall() {
  run_install
  if [ ! -f "$manifest" ]; then
    fail "expected a manifest at $manifest"
  fi
  assert_contains "$(cat "$manifest" 2>/dev/null)" "alpha.md"
  if [ "$(grep -c . "$manifest" 2>/dev/null)" != "2" ]; then
    fail "expected two manifest lines, got: $(cat "$manifest" 2>/dev/null)"
  fi
  run_install
  if [ "$(grep -c . "$manifest" 2>/dev/null)" != "2" ]; then
    fail "expected a repeat install to keep two manifest lines"
  fi
  run_install --uninstall
  assert_absent "$manifest"
}

test_manifest_entry_is_dropped_when_the_file_is_already_gone() {
  run_install
  rm "$dest/alpha.md"
  run_install --uninstall
  assert_status 0
  assert_absent "$manifest"
}

# An install from before the manifest existed is still recognised: a link to
# the source, or a copy identical to it.
test_install_without_a_manifest_is_still_recognised() {
  run_install
  rm "$manifest"
  run_install --uninstall
  assert_status 0
  assert_absent "$dest/alpha.md"

  run_install --copy
  rm "$manifest"
  run_install --uninstall
  assert_status 0
  assert_absent "$dest/alpha.md"
}

# --- Options and errors ------------------------------------------------------

test_help_prints_usage() {
  run_install --help
  assert_status 0
  assert_contains "$out" "Usage: scripts/install.sh"
  assert_absent "$dest"
  run_install -h
  assert_status 0
}

test_unknown_option_fails() {
  run_install --nope
  assert_status 2
  assert_contains "$err" "Unknown option: --nope"
  assert_contains "$err" "Usage: scripts/install.sh"
  assert_absent "$dest"
}

test_fails_when_there_are_no_agents() {
  rm "$fixture/agents/"*.md
  run_install
  assert_status 1
  assert_contains "$err" "No agent files found"
}

# --- Run ---------------------------------------------------------------------

for name in $(declare -F | awk '{ print $3 }' | grep '^test_'); do
  run_test "$name"
done

echo
echo "$tests_run tests, $tests_failed failed"

# --- Coverage ----------------------------------------------------------------
#
# Line coverage of scripts/install.sh, measured from the xtrace output of the
# runs above. A line counts as executable when it holds a command: blank
# lines, comments, the usage text, function headers, case patterns and
# closing keywords are left out.

executable="$scratch/executable"
awk '
  in_heredoc { if ($0 == "EOF") in_heredoc = 0; next }
  /<<.EOF.$/ { print NR; in_heredoc = 1; next }
  /^[[:space:]]*$/ { next }
  /^[[:space:]]*#/ { next }
  /^[[:space:]]*(\}|fi|done|esac|else|then|do|;;)[[:space:]]*$/ { next }
  /^[a-z_]+\(\) \{$/ { next }
  /^[[:space:]]*[-*a-z| ]+\)$/ { next }
  { print NR }
' "$script" | sort -n >"$executable"

executed="$scratch/executed"
sed -E 's/^\++COV:([0-9]+): .*/\1/' "$trace" | sort -n | uniq >"$executed"

total="$(grep -c . "$executable")"
missed_lines="$(comm -23 <(sort "$executable") <(sort "$executed") | sort -n | tr '\n' ' ')"
missed="$(echo "$missed_lines" | wc -w | tr -d ' ')"
covered=$((total - missed))
percent=$((covered * 100 / total))

echo "coverage: $covered of $total executable lines in scripts/install.sh ($percent%), minimum $coverage_min%"
if [ "$missed" -gt 0 ]; then
  echo "lines not executed: $missed_lines"
fi

if [ "$tests_failed" -gt 0 ]; then
  exit 1
fi
if [ "$percent" -lt "$coverage_min" ]; then
  echo "coverage is below the minimum"
  exit 1
fi
