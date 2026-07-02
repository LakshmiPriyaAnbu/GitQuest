import { randomBytes } from 'node:crypto';

const SEED_FILES = ['index.html', 'app.ts', 'styles.css', 'README.md'];
const SUPPORTED = ['init', 'add', 'commit', 'branch', 'checkout', 'switch', 'merge', 'log', 'status', 'diff', 'reset'];

function genSha() {
  return randomBytes(4).toString('hex').slice(0, 7);
}

function line(k, t) {
  return { k, t };
}

export function freshState() {
  return {
    initialized: false,
    workingDir: SEED_FILES.map((name) => ({ name, state: 'untracked' })),
    staging: [],
    commits: {},
    order: [],
    branches: {},
    head: { type: 'branch', ref: 'main' },
    history: [],
    output: [
      line('sys', 'Welcome to the GitQuest playground.'),
      line('dim', 'Type a git command below, or tap a suggestion to get started.'),
    ],
    explain: { title: 'Ready to start', body: 'Run "git init" to create your first repository.' },
    conflict: null,
  };
}

function headSha(state) {
  return state.branches[state.head.ref] ?? null;
}

function isAncestor(state, a, b) {
  if (a == null) return true;
  if (a === b) return true;
  let frontier = [b];
  const seen = new Set();
  let guard = 0;
  while (frontier.length && guard < 200) {
    guard++;
    const next = [];
    for (const id of frontier) {
      if (id == null || seen.has(id)) continue;
      seen.add(id);
      if (id === a) return true;
      const c = state.commits[id];
      if (c) next.push(...c.parents);
    }
    frontier = next;
  }
  return false;
}

function tokenize(raw) {
  const matches = raw.match(/"[^"]*"|\S+/g) || [];
  return matches.map((t) => (t.startsWith('"') && t.endsWith('"') ? t.slice(1, -1) : t));
}

function explain(state, title, body) {
  state.explain = { title, body };
}

export function run(state, raw) {
  const events = [];
  const tokens = tokenize((raw || '').trim());
  state.history.push(raw);

  if (tokens.length === 0) {
    return { state, events };
  }

  if (tokens[0] !== 'git') {
    state.output.push(line('err', 'gitquest: only "git" commands run here.'));
    return { state, events };
  }

  const sub = tokens[1];

  if (sub !== 'init' && !state.initialized) {
    state.output.push(line('err', 'fatal: not a git repository. Run "git init" first.'));
    return { state, events };
  }

  switch (sub) {
    case 'init': {
      if (state.initialized) {
        state.output.push(line('sys', 'Reinitialized existing Git repository.'));
        break;
      }
      state.initialized = true;
      state.branches = { main: null };
      state.head = { type: 'branch', ref: 'main' };
      state.output.push(line('ok', 'Initialized empty Git repository.'));
      explain(state, 'Repository initialized', 'Git now tracks this folder. Your files start out untracked in the workspace camp.');
      events.push({ type: 'quest', id: 'q1', title: 'Create your first repository', xp: 15 });
      events.push({ type: 'xp', amount: 10, reason: 'First git init' });
      break;
    }

    case 'status': {
      state.output.push(line('plain', `On branch ${state.head.ref}`));
      if (state.staging.length === 0 && state.workingDir.length === 0) {
        state.output.push(line('dim', 'nothing to commit, working tree clean'));
      } else {
        if (state.staging.length) {
          state.output.push(line('dim', 'Changes to be committed:'));
          for (const f of state.staging) state.output.push(line('ok', `  new file:   ${f.name}`));
        }
        if (state.workingDir.length) {
          state.output.push(line('dim', 'Untracked files:'));
          for (const f of state.workingDir) state.output.push(line('err', `  ${f.name}`));
        }
      }
      break;
    }

    case 'add': {
      const target = tokens[2];
      if (!target) {
        state.output.push(line('err', 'Nothing specified, nothing added.'));
        break;
      }
      let staged = [];
      if (target === '.' || target === '-A') {
        staged = state.workingDir.splice(0, state.workingDir.length);
      } else {
        const idx = state.workingDir.findIndex((f) => f.name === target);
        if (idx === -1) {
          const alreadyStaged = state.staging.some((f) => f.name === target);
          if (!alreadyStaged) {
            state.output.push(line('err', `fatal: pathspec '${target}' did not match any files`));
            break;
          }
        } else {
          staged = state.workingDir.splice(idx, 1);
        }
      }
      for (const f of staged) {
        state.staging.push({ name: f.name });
        state.output.push(line('ok', `added '${f.name}' to staging`));
      }
      if (staged.length) {
        explain(state, 'Files staged', 'Staged files move to the backpack — ready to travel into your next commit.');
        events.push({ type: 'quest', id: 'q2', title: 'Stage your first file', xp: 15 });
        events.push({ type: 'xp', amount: 8, reason: 'Staged changes' });
      }
      break;
    }

    case 'commit': {
      const mIdx = tokens.indexOf('-m');
      if (mIdx === -1 || !tokens[mIdx + 1]) {
        state.output.push(line('err', "error: switch 'm' requires a value"));
        break;
      }
      if (state.staging.length === 0) {
        state.output.push(line('err', 'nothing to commit, working tree clean'));
        break;
      }
      const msg = tokens[mIdx + 1];
      const parentSha = headSha(state);
      const sha = genSha();
      const commit = {
        id: sha,
        msg,
        parents: parentSha ? [parentSha] : [],
        files: state.staging.map((f) => f.name),
        branch: state.head.ref,
        time: Date.now(),
        author: 'you',
      };
      state.commits[sha] = commit;
      state.order.push(sha);
      state.branches[state.head.ref] = sha;
      state.staging = [];
      state.output.push(line('ok', `[${state.head.ref} ${sha}] ${msg}`));
      explain(state, 'Commit created', 'A glowing commit crystal now holds a snapshot of your staged files.');
      events.push({ type: 'quest', id: 'q3', title: 'Make your first commit', xp: 20 });
      events.push({ type: 'badge', id: 'first-commit', title: 'First Commit' });
      events.push({ type: 'xp', amount: 15, reason: 'Commit created' });
      break;
    }

    case 'log': {
      let cur = headSha(state);
      if (!cur) {
        state.output.push(line('err', "fatal: your current branch '" + state.head.ref + "' does not have any commits yet"));
        break;
      }
      let guard = 0;
      while (cur && guard < 60) {
        guard++;
        const c = state.commits[cur];
        if (!c) break;
        const headTag = cur === headSha(state) ? `  (HEAD -> ${state.head.ref})` : '';
        state.output.push(line('plain', `commit ${cur}${headTag}`));
        state.output.push(line('dim', `    ${c.msg}`));
        cur = c.parents[0] ?? null;
      }
      break;
    }

    case 'branch': {
      const name = tokens[2];
      if (!name) {
        for (const b of Object.keys(state.branches)) {
          const marker = b === state.head.ref ? '*' : ' ';
          state.output.push(line(b === state.head.ref ? 'ok' : 'plain', `${marker} ${b}`));
        }
        break;
      }
      if (state.branches[name] !== undefined) {
        state.output.push(line('err', `fatal: a branch named '${name}' already exists`));
        break;
      }
      if (state.order.length === 0) {
        state.output.push(line('err', "fatal: not a valid object name: 'HEAD'"));
        break;
      }
      state.branches[name] = headSha(state);
      state.output.push(line('ok', `Branch '${name}' created.`));
      explain(state, 'Branch created', 'A new path forks off from your current commit — the original line keeps going too.');
      events.push({ type: 'quest', id: 'q4', title: 'Create a branch', xp: 15 });
      events.push({ type: 'badge', id: 'brancher', title: 'Branch Explorer' });
      events.push({ type: 'xp', amount: 10, reason: 'New branch created' });
      break;
    }

    case 'checkout':
    case 'switch': {
      const isCreate = tokens[2] === '-b' || tokens[2] === '-c';
      const name = isCreate ? tokens[3] : tokens[2];
      if (!name) {
        state.output.push(line('err', `${sub} requires a branch name`));
        break;
      }
      if (isCreate) {
        if (state.branches[name] !== undefined) {
          state.output.push(line('err', `fatal: a branch named '${name}' already exists`));
          break;
        }
        if (state.order.length === 0) {
          state.output.push(line('err', "fatal: not a valid object name: 'HEAD'"));
          break;
        }
        state.branches[name] = headSha(state);
        state.head = { type: 'branch', ref: name };
        state.output.push(line('ok', `Switched to a new branch '${name}'`));
        explain(state, 'Branch created & switched', "HEAD now points at your new branch — commits will land here.");
        events.push({ type: 'quest', id: 'q4', title: 'Create a branch', xp: 15 });
        events.push({ type: 'quest', id: 'q5', title: 'Switch branches', xp: 15 });
        events.push({ type: 'badge', id: 'brancher', title: 'Branch Explorer' });
        events.push({ type: 'xp', amount: 10, reason: 'New branch created' });
      } else {
        if (state.branches[name] === undefined) {
          state.output.push(line('err', `error: pathspec '${name}' did not match any branch known to git`));
          break;
        }
        state.head = { type: 'branch', ref: name };
        state.output.push(line('ok', `Switched to branch '${name}'`));
        explain(state, 'HEAD moved', `You're now working on "${name}". New commits will move this branch's pointer.`);
        events.push({ type: 'quest', id: 'q5', title: 'Switch branches', xp: 15 });
        events.push({ type: 'xp', amount: 8, reason: 'Switched branch' });
      }
      break;
    }

    case 'merge': {
      const target = tokens[2];
      if (!target) {
        state.output.push(line('err', 'merge: branch name required'));
        break;
      }
      if (state.branches[target] === undefined) {
        state.output.push(line('err', `merge: ${target} - not something we can merge`));
        break;
      }
      const cur = state.head.ref;
      if (target === cur) {
        state.output.push(line('dim', 'Already up to date.'));
        break;
      }
      const curSha = state.branches[cur];
      const targetSha = state.branches[target];
      if (curSha === targetSha) {
        state.output.push(line('dim', 'Already up to date.'));
      } else if (isAncestor(state, curSha, targetSha)) {
        state.branches[cur] = targetSha;
        state.output.push(line('ok', `Fast-forward`));
        state.output.push(line('dim', `${curSha ?? '(none)'}..${targetSha}`));
        explain(state, 'Fast-forward merge', 'Main had not moved, so Git just slid the pointer forward — no merge commit needed.');
        events.push({ type: 'quest', id: 'q6', title: 'Merge a feature branch', xp: 25 });
        events.push({ type: 'badge', id: 'merger', title: 'Merge Master' });
        events.push({ type: 'xp', amount: 15, reason: 'Fast-forward merge' });
      } else if (isAncestor(state, targetSha, curSha)) {
        state.output.push(line('dim', 'Already up to date.'));
      } else {
        const sha = genSha();
        const commit = {
          id: sha,
          msg: `Merge branch '${target}' into ${cur}`,
          parents: [curSha, targetSha].filter(Boolean),
          files: [],
          branch: cur,
          time: Date.now(),
          author: 'you',
          isMerge: true,
        };
        state.commits[sha] = commit;
        state.order.push(sha);
        state.branches[cur] = sha;
        state.output.push(line('ok', "Merge made by the 'ort' strategy."));
        explain(state, 'Three-way merge', 'Both branches had new commits, so Git wove them together with a merge commit that has two parents.');
        events.push({ type: 'quest', id: 'q6', title: 'Merge a feature branch', xp: 25 });
        events.push({ type: 'badge', id: 'merger', title: 'Merge Master' });
        events.push({ type: 'xp', amount: 18, reason: 'Three-way merge' });
      }
      break;
    }

    case 'diff': {
      if (state.workingDir.length === 0 && state.staging.length === 0) {
        state.output.push(line('dim', 'No changes.'));
        break;
      }
      if (state.workingDir.length === 0) {
        state.output.push(line('dim', 'No changes in the working tree; changes are staged. Try: git diff --staged'));
        break;
      }
      for (const f of state.workingDir) {
        state.output.push(line('plain', `diff --git a/${f.name} b/${f.name}`));
        state.output.push(line('ok', `+ // new content in ${f.name}`));
      }
      break;
    }

    case 'reset': {
      for (const f of state.staging) state.workingDir.push({ name: f.name, state: 'untracked' });
      state.staging = [];
      state.output.push(line('sys', 'Reset complete.'));
      break;
    }

    default: {
      state.output.push(
        line('err', `git: '${sub}' is not a git command we simulate here. Try: ${SUPPORTED.join(', ')}`)
      );
    }
  }

  return { state, events };
}

function ensureBase(state) {
  if (!state.initialized) {
    run(state, 'git init');
  }
  if (state.order.length === 0) {
    state.staging.push({ name: 'README.md' });
    state.workingDir = state.workingDir.filter((f) => f.name !== 'README.md');
    run(state, 'git commit -m "Initial commit"');
  }
}

function nextFeatureName(state) {
  const base = 'feature-ui';
  if (state.branches[base] === undefined) return base;
  let i = 2;
  while (state.branches[`feature-${i}`] !== undefined) i++;
  return `feature-${i}`;
}

export function simNewBranch(state) {
  const events = [];
  ensureBase(state);
  const name = nextFeatureName(state);
  state.branches[name] = state.branches[state.head.ref];
  state.head = { type: 'branch', ref: name };
  explain(state, 'Branch created & switched', "HEAD now points at your new branch — commits will land here.");
  events.push({ type: 'quest', id: 'q4', title: 'Create a branch', xp: 15 });
  events.push({ type: 'quest', id: 'q5', title: 'Switch branches', xp: 15 });
  events.push({ type: 'badge', id: 'brancher', title: 'Branch Explorer' });
  events.push({ type: 'xp', amount: 10, reason: 'New branch created' });
  return { state, events, message: `Created and switched to '${name}'` };
}

export function simCommit(state) {
  const events = [];
  ensureBase(state);
  const branch = state.head.ref;
  const file = branch === 'main' ? 'update.md' : `${branch}.ts`;
  const sha = genSha();
  const parentSha = state.branches[branch];
  state.commits[sha] = {
    id: sha,
    msg: `Update ${file}`,
    parents: parentSha ? [parentSha] : [],
    files: [file],
    branch,
    time: Date.now(),
    author: 'you',
  };
  state.order.push(sha);
  state.branches[branch] = sha;
  explain(state, 'Commit created', 'A glowing commit crystal now holds a snapshot of your staged files.');
  events.push({ type: 'quest', id: 'q3', title: 'Make your first commit', xp: 20 });
  events.push({ type: 'badge', id: 'first-commit', title: 'First Commit' });
  events.push({ type: 'xp', amount: 12, reason: 'Commit added via simulator' });
  return { state, events, message: `Committed on '${branch}'` };
}

export function simMerge(state) {
  ensureBase(state);
  const feature = Object.keys(state.branches).find((b) => b !== 'main');
  if (!feature) {
    return { state, events: [], message: 'Nothing to merge — create a branch first.' };
  }
  const wasHead = state.head.ref;
  state.head = { type: 'branch', ref: 'main' };
  const { events } = run(state, `git merge ${feature}`);
  if (!events.length) state.head = { type: 'branch', ref: wasHead };
  return { state, events, message: `Merged '${feature}' into main` };
}

export function armConflict(state) {
  state.conflict = {
    file: 'styles.css',
    ours: ['.hero-btn{background:#43E197;border-radius:14px;}'],
    theirs: ['.hero-btn{background:#FF6B9D;border-radius:20px;}'],
  };
  return { state, events: [], message: 'Conflict armed' };
}

export function dismissConflict(state) {
  state.conflict = null;
  return { state, events: [], message: 'Conflict dismissed' };
}

export function resolveConflict(state, choice) {
  const events = [];
  ensureBase(state);
  if (state.branches['feature-ui'] === undefined) {
    state.branches['feature-ui'] = state.branches[state.head.ref];
  }
  const cur = state.head.ref;
  const curSha = state.branches[cur];
  const targetSha = state.branches['feature-ui'];
  const labels = { current: 'kept current', incoming: 'kept incoming', both: 'combined both' };
  const label = labels[choice] || 'resolved manually';
  const sha = genSha();
  const parents = [...new Set([curSha, targetSha].filter(Boolean))];
  state.commits[sha] = {
    id: sha,
    msg: `Merge feature-ui (resolved: ${label})`,
    parents,
    files: [state.conflict?.file || 'styles.css'],
    branch: cur,
    time: Date.now(),
    author: 'you',
    isMerge: true,
  };
  state.order.push(sha);
  state.branches[cur] = sha;
  state.conflict = null;
  explain(state, 'Conflict resolved', 'You chose how the lines should read, then Git recorded that choice in a merge commit.');
  events.push({ type: 'quest', id: 'q7', title: 'Resolve a conflict', xp: 30 });
  events.push({ type: 'badge', id: 'merger', title: 'Merge Master' });
  events.push({ type: 'xp', amount: 25, reason: 'Conflict resolved' });
  return { state, events, message: 'Conflict resolved' };
}

export { isAncestor, headSha };
