#!/bin/sh
# Guarded database wrapper driven by the profile: db.sh status|migrate|seed|reset|snapshot|restore|psql
# Agents use only this (changes) and `psql` (read-only command from the profile). Never production.
. "$(dirname "$0")/lib.sh"; . "$(dirname "$0")/_profile.sh"
case "${DB_TARGET:-}" in local|dev) ;; *) die "DB_TARGET must be local or dev (is '${DB_TARGET:-unset}'). Agents never touch other targets." ;; esac
case "$(printf '%s' "${DATABASE_URL:-}" | tr 'A-Z' 'a-z')" in *prod*) die "DATABASE_URL looks like production. Refusing." ;; esac
cmd=${1:-status}
case "$cmd" in
  status)   run "$DB_STATUS_CMD" ;;
  migrate)  run "$DB_MIGRATE_CMD" ;;
  seed)     run "$DB_SEED_CMD" ;;
  reset)    run "$DB_RESET_CMD" ;;
  snapshot) run "$DB_SNAPSHOT_CMD" ;;
  restore)  run "$DB_RESTORE_CMD" ;;
  psql|read) shift; run "$DB_READONLY_CMD $*" ;;
  *) die "usage: db.sh status|migrate|seed|reset|snapshot|restore|psql" ;;
esac
