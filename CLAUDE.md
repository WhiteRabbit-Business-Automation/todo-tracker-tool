# todo-tracker-tool — Agent Instructions

## What This Is
White Rabbit team task tracker. Markdown files, local git, GitHub backup.
Each person owns one file. Push directly to main. No branches, no PRs.

## Where Tasks Live
Tasks exist in exactly two places:
- Person files: Miguel.md, Jamie.md, Andres.md
- Backlog.md
Nowhere else.

## File Structure
- Miguel.md   — Miguel's tasks only
- Jamie.md    — Jamie's tasks only
- Andres.md   — Andres's tasks only
- Backlog.md  — Unassigned team items
- sync.log    — Local error log, not git-tracked

## Task Format (person files)
- C### ClientName: description #tag

Valid tags: #urgent, #blocked, #backlog
Tags at end of line. One task per line. No sub-bullets.
New tasks always go at the TOP of the file.
Done tasks: delete the line (git history is the record).

## Backlog Format
- Plain description  (no C### prefix required)

## How to Create a Task for a Person
PREPEND to the top of the person's file:
  - C103 HCCG: review proposal #urgent

## How to Add an Item to Backlog
APPEND a plain bullet to Backlog.md:
  - Automated client onboarding pipeline

## How to Move a Backlog Item to a Person
1. Remove the bullet line from Backlog.md
2. Prepend as a task to the top of the person's file:
   - Description #tag

## How to Complete a Task
Delete the line from the person's file. Git history preserves it.

## How to View All Tasks
Read each person's file. All lines are open tasks.

## How to Check for Sync Problems
Read the log file at: ~/todo-tracker-tool/sync.log
If the file is empty or does not exist, there are no errors — sync is healthy.

Log format:
  [YYYY-MM-DD HH:MM:SS] TYPE: message

Error types and what to do:

CONFLICT — A merge conflict occurred (most likely in Backlog.md).
  The file contains <<<<<<< markers. Open it, resolve the conflict manually
  (keep the correct content, remove the markers), save the file.
  The next cron run will pick it up automatically.

PUSH_FAILED — The push to GitHub failed.
  Usually a network issue or auth problem. No data was lost — the commit
  exists locally. The next cron run will retry the push automatically.

PULL_FAILED — The pull from GitHub failed.
  Usually caused by an unresolved conflict or detached HEAD state.
  Check git status in ~/todo-tracker-tool for more detail.

When a user asks "is something wrong with sync?" or "did my task push?",
read sync.log, summarize the last few entries, and explain what happened
in plain language. Do not show raw log output unless asked.

## Git Rules
Push directly to main. Cron (running sync.sh every minute) handles all git ops.
Conflict markers (<<<<<<) mean a manual fix is needed before next sync.

## Convention (not enforced)
Each person edits their own file. Agents may edit any file when explicitly instructed.
