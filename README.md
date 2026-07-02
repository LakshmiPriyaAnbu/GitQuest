# GitQuest

GitQuest is an interactive Git internals and GitHub activity visualizer that teaches version control concepts through command simulation, commit graphs, branch maps, quests, XP, and developer activity insights.

Type real git commands in the Playground and watch files move from your workspace to the staging area to commits; explore your history as a branching quest map; fork and merge branches (including a guided merge-conflict scenario); work through a Command Lab of git lessons with quizzes; and turn any public GitHub profile into a gamified activity dashboard.

## Stack

Angular 22 (client) + Express (server), with the simulated git repo's state and command logic living entirely on the server and XP/badges/quests/settings persisted in the browser. See [CLAUDE.md](CLAUDE.md) for the full architecture.

## Getting started

```bash
npm run install:all
npm run dev
```

Then open http://localhost:4200. See [`.claude/skills/run.md`](.claude/skills/run.md) for the production-style single-process run, the Node version requirement, and a quick smoke check.
