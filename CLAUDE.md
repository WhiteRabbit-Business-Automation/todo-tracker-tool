# todo-tracker-tool — Agent Instructions

## What This Is
White Rabbit team task tracker. Markdown files, local git, GitHub backup.
Each person owns one file. Push directly to main. No branches, no PRs.

## Where Tasks Live
Tasks exist in exactly two places:
- Person files: Miguel.md, Jamie.md, Andres.md
- Backlog.md

TaskLog.md is the central record of all tasks (in progress + completed). It is NOT a place to find open tasks — read the person files for that.

## File Structure
- Miguel.md   — Miguel's open tasks only
- Jamie.md    — Jamie's open tasks only
- Andres.md   — Andres's open tasks only
- Backlog.md  — Unassigned team items
- TaskLog.md  — All tasks: in progress and completed (with dates and hours)
- sync.log    — Local error log, not git-tracked

## Task Format (person files)
- C### ClientName: description #tag start:YYYY-MM-DD

Valid tags: #urgent, #blocked, #backlog
Tags before start date. One task per line. No sub-bullets.
New tasks always go at the TOP of the file.

## Backlog Format
- Plain description  (no C### prefix required)

## TaskLog.md Format
A Markdown table. Newest rows go at the TOP (first row after the header separator).

| Task | Description | Assignee | Start | End | Hours | Status |
|------|-------------|----------|-------|-----|-------|--------|
| C103 | HCCG: review proposal | Miguel | 2026-03-20 | 2026-03-26 | 6.5 | Done |
| C114 | Little Pie Co: kickoff prep | Jamie | 2026-03-25 | — | — | In Progress |

- Task: use C### for client tasks, or a short label (e.g. "ClawBot") for internal tasks
- End and Hours are — when the task is still in progress
- Hours is a decimal number (e.g. 4.5, not "4h 30m")
- Status: "In Progress" or "Done"

## How to Create a Task for a Person
Do both steps:
1. PREPEND to the top of the person's file:
   - C103 HCCG: review proposal #urgent start:2026-03-20
2. PREPEND a new row to TaskLog.md (insert after the header separator line):
   | C103 | HCCG: review proposal | Miguel | 2026-03-20 | — | — | In Progress |

## How to Add an Item to Backlog
APPEND a plain bullet to Backlog.md:
  - Automated client onboarding pipeline

## How to Move a Backlog Item to a Person
1. Remove the bullet line from Backlog.md
2. Do both steps from "How to Create a Task for a Person" above

## How to Complete a Task
Do both steps:
1. Delete the line from the person's file
2. In TaskLog.md, find the matching row and update it:
   - Set End to today's date
   - Calculate Hours as the number of days × estimated daily hours, or use the actual hours if provided
   - Change Status from "In Progress" to "Done"

## How to View All Open Tasks
Read each person's file. All lines are open tasks.

## How to View Task History / Time Tracking
Read TaskLog.md. Rows with Status "Done" are completed. Rows with "In Progress" match what's in person files.

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

## Scope — this is NOT the CRM
This tracker owns personal next actions only. Client pipeline status and activity history
live in the CRM (`WR-02.CRM/`). Tasks here may reference C### clients but don't track
deal stage, contacts, or activity logs — that's CRM territory.

## Convention (not enforced)
Each person edits their own file. Agents may edit any file when explicitly instructed.
