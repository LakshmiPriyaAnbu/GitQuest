import { Router } from 'express';
import {
  freshState,
  run,
  simNewBranch,
  simCommit,
  simMerge,
  armConflict,
  dismissConflict,
  resolveConflict,
} from '../gitEngine.js';

const router = Router();

function getState(req) {
  if (!req.session.git) req.session.git = freshState();
  return req.session.git;
}

router.get('/state', (req, res) => {
  res.json({ state: getState(req) });
});

router.post('/command', (req, res) => {
  const state = getState(req);
  const { state: next, events } = run(state, String(req.body?.command ?? ''));
  req.session.git = next;
  res.json({ state: next, events });
});

router.post('/reset', (req, res) => {
  req.session.git = freshState();
  res.json({ state: req.session.git, events: [] });
});

router.post('/branch-sim', (req, res) => {
  const state = getState(req);
  const { state: next, events, message } = simNewBranch(state);
  req.session.git = next;
  res.json({ state: next, events, message });
});

router.post('/commit-sim', (req, res) => {
  const state = getState(req);
  const { state: next, events, message } = simCommit(state);
  req.session.git = next;
  res.json({ state: next, events, message });
});

router.post('/merge-sim', (req, res) => {
  const state = getState(req);
  const { state: next, events, message } = simMerge(state);
  req.session.git = next;
  res.json({ state: next, events, message });
});

router.post('/conflict/arm', (req, res) => {
  const state = getState(req);
  const { state: next, events, message } = armConflict(state);
  req.session.git = next;
  res.json({ state: next, events, message });
});

router.post('/conflict/dismiss', (req, res) => {
  const state = getState(req);
  const { state: next, events, message } = dismissConflict(state);
  req.session.git = next;
  res.json({ state: next, events, message });
});

router.post('/conflict/resolve', (req, res) => {
  const state = getState(req);
  const choice = String(req.body?.choice ?? 'current');
  const { state: next, events, message } = resolveConflict(state, choice);
  req.session.git = next;
  res.json({ state: next, events, message });
});

export default router;
