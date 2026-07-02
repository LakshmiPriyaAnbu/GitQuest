---
name: run
description: Launch GitQuest (Angular client + Express server) locally to see a change working. Use when asked to run, start, or screenshot the app, or confirm a change works end-to-end.
---

GitQuest is a two-process app: an Angular SPA in `client/` and an Express API/session server in `server/` that owns the simulated git repo state.

## Prerequisites

Angular 22 requires Node >=22.22.3 or >=24.15.0. If the default `node -v` doesn't satisfy that, install an isolated version and the root scripts will pick it up automatically:

```bash
brew install node@22   # keg-only, does not touch the system default node
```

`scripts/with-node22.sh` (used by the root `dev`/`build` scripts) checks the active Node version and prepends `node@22`'s bin dir to PATH only if needed — no manual PATH exports required.

## First run

```bash
npm run install:all   # installs client/ and server/ deps
```

## Dev mode (hot reload, two processes)

```bash
npm run dev
```

This runs `ng serve` on :4200 (proxying `/api/**` to :3000 per `client/proxy.conf.json`) and `nodemon` on the Express server on :3000, concurrently. Open http://localhost:4200.

## Production-style check (single process, what a real deploy looks like)

```bash
npm run build            # builds client/dist/client/browser
node server/src/index.js # serves the build + API on :3000
```

Open http://localhost:3000 — Express serves the built Angular app and the `/api/git/*` and `/api/github/*` routes from the same origin (this is also how the git-session cookie works without CORS).

## One representative interaction to confirm it's alive

```bash
curl -s http://localhost:3000/api/git/state   # should return {"state": {...}}
```

Then in a browser: Dashboard → "Start Git Quest" → type `git init` in the Playground terminal → Enter. The terminal should print "Initialized empty Git repository." and a `+XP` toast should appear bottom-right.

## Gotchas

- Starting the server with a bare `command &` inside a single Bash call gets killed when that shell exits — background it properly (the harness's `run_in_background` option, or `nohup`/a process manager) if you need it to outlive the current command.
- If port 3000 is already bound from a previous run: `lsof -ti:3000 | xargs kill -9`.
- The simulated git repo lives in an in-memory `express-session` store — it resets on server restart. XP/badges/quests/settings persist separately in the browser's `localStorage` and survive server restarts.
