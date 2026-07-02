import { BadgeDef, QuestDef } from './models';

export const LEVEL_TIERS = [0, 60, 160, 320, 560, 900, 1400, 2000];
export const LEVEL_TITLES = [
  'Newbie',
  'Sprout',
  'Committer',
  'Brancher',
  'Merge Mage',
  'Repo Ranger',
  'Git Wizard',
  'Legend',
];

export const QUESTS: QuestDef[] = [
  { id: 'q1', title: 'Create your first repository', difficulty: 'Easy', minutes: 1, xp: 15, hint: 'git init', route: '/playground' },
  { id: 'q2', title: 'Stage your first file', difficulty: 'Easy', minutes: 1, xp: 15, hint: 'git add index.html', route: '/playground' },
  { id: 'q3', title: 'Make your first commit', difficulty: 'Easy', minutes: 2, xp: 20, hint: 'git commit -m "…"', route: '/playground' },
  { id: 'q4', title: 'Create a branch', difficulty: 'Medium', minutes: 2, xp: 15, hint: 'git branch feature-ui', route: '/branches' },
  { id: 'q5', title: 'Switch branches', difficulty: 'Medium', minutes: 1, xp: 15, hint: 'git checkout feature-ui', route: '/branches' },
  { id: 'q6', title: 'Merge a feature branch', difficulty: 'Medium', minutes: 3, xp: 25, hint: 'git merge feature-ui', route: '/branches' },
  { id: 'q7', title: 'Resolve a conflict', difficulty: 'Hard', minutes: 4, xp: 30, hint: 'Conflict battle', route: '/branches' },
  { id: 'q8', title: 'Read a commit graph', difficulty: 'Easy', minutes: 2, xp: 20, hint: 'Open the map', route: '/commitmap' },
];

export const BADGES: BadgeDef[] = [
  { id: 'first-commit', emoji: '💎', title: 'First Commit', hint: 'Make your first commit' },
  { id: 'brancher', emoji: '🌿', title: 'Branch Explorer', hint: 'Create a branch' },
  { id: 'merger', emoji: '🔀', title: 'Merge Master', hint: 'Merge a branch' },
  { id: 'streak', emoji: '🔥', title: 'Streak Keeper', hint: 'Reach a 7-day GitHub streak' },
  { id: 'oss', emoji: '🧭', title: 'Open Source Adventurer', hint: 'Scan a GitHub profile' },
  { id: 'bughunter', emoji: '🐛', title: 'Bug Hunter', hint: 'Open a GitHub issue' },
  { id: 'repo', emoji: '🏗️', title: 'Repo Builder', hint: 'Have 3+ public repos' },
  { id: 'pr', emoji: '🎯', title: 'Pull Request Hero', hint: 'Open a pull request' },
];
