#!/bin/bash
# todo-tracker-tool sync script (one-shot — invoked by cron every minute)
# Stage 1: commit local changes if any (before pull, to avoid overwriting open files)
# Stage 2: pull always, then push if Stage 1 committed

VAULT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$VAULT_DIR/sync.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1: $2" >> "$LOG"
  tail -200 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
}

cd "$VAULT_DIR" || exit 1
committed=false

# Stage 1 — commit local changes if any
if [ -n "$(git status --porcelain)" ]; then
  commit_out=$(git add -A && git commit -m "auto: $(date '+%Y-%m-%d %H:%M:%S')" 2>&1)
  commit_exit=$?
  if [ $commit_exit -eq 0 ]; then
    log "COMMIT_OK" "local changes committed"
    committed=true
  else
    log "COMMIT_FAILED" "$(echo "$commit_out" | head -1)"
  fi
fi

# Stage 2 — pull always, push if we committed or if there are unpushed commits
pull_out=$(git pull --rebase origin main 2>&1)
pull_exit=$?

if [ $pull_exit -ne 0 ]; then
  if echo "$pull_out" | grep -qi "conflict"; then
    log "CONFLICT" "merge conflict — manual fix required"
  else
    log "PULL_FAILED" "$(echo "$pull_out" | head -1)"
  fi
  exit 1
else
  log "PULL_OK" "in sync with origin/main"
fi

if [ "$committed" = true ] || [ -n "$(git log origin/main..HEAD --oneline 2>/dev/null)" ]; then
  push_out=$(git push origin main 2>&1)
  push_exit=$?
  if [ $push_exit -eq 0 ]; then
    log "PUSH_OK" "pushed to origin/main"
  else
    log "PUSH_FAILED" "$(echo "$push_out" | head -1)"
  fi
fi
