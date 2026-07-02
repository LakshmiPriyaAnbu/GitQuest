#!/usr/bin/env bash
# Angular 22 requires Node >=22.22.3 or >=24.15.0. Prepend a compatible
# Homebrew-installed node@22 to PATH if the active node doesn't qualify.
set -e

node_ok() {
  node -e '
    const [maj, min, patch] = process.versions.node.split(".").map(Number);
    const ok = (maj === 22 && (min > 22 || (min === 22 && patch >= 3))) || (maj === 24 && (min > 15 || (min === 15 && patch >= 0))) || maj >= 26;
    process.exit(ok ? 0 : 1);
  ' 2>/dev/null
}

if ! node_ok; then
  for candidate in /opt/homebrew/opt/node@22/bin /usr/local/opt/node@22/bin; do
    if [ -d "$candidate" ]; then
      export PATH="$candidate:$PATH"
      break
    fi
  done
fi

exec "$@"
