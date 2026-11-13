#!/bin/sh
# Append one line to the run ledger under today's heading: ledger.sh "<slice> / <worker> / <gate> / <outcome>"
. "$(dirname "$0")/lib.sh"
[ -n "$1" ] || die 'usage: ledger.sh "<slice> / <worker> / <gate result> / <outcome>"'
f="$CORE_ROOT/$CORE_LEDGER"; today=$(date +%Y-%m-%d)
[ -f "$f" ] || { mkdir -p "$(dirname "$f")"; printf '# Run ledger\n\n' > "$f"; }
grep -q "^## $today" "$f" || printf '\n## %s\n\n' "$today" >> "$f"
printf -- '- %s\n' "$*" >> "$f"; echo "ledger: $*"
