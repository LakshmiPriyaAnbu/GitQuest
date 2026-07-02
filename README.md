# GitQuest

**Live demo: [gitquest-y41k.onrender.com](https://gitquest-y41k.onrender.com)** *(free tier — the first request after idle may take ~30–50 s to wake the server)*

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

## Deploying

`render.yaml` at the repo root is a ready-to-use [Render](https://render.com) Blueprint — in the Render dashboard, choose New → Blueprint and select this repo. See the "Deployment" section in [CLAUDE.md](CLAUDE.md) for what it configures and the free-tier tradeoffs.
