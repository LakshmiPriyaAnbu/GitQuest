export interface QuizOption {
  t: string;
  correct: boolean;
}

export interface Lesson {
  id: string;
  cmd: string;
  blurb: string;
  syntax: string;
  example: string;
  from: string;
  to: string;
  file: string;
  mistakes: string[];
  quiz: { q: string; options: QuizOption[] };
}

export const LESSONS: Lesson[] = [
  {
    id: 'init',
    cmd: 'git init',
    blurb: 'Turns the current folder into a Git repository by creating a hidden .git directory.',
    syntax: 'git init',
    example: 'git init',
    from: 'plain folder',
    to: 'folder + .git/',
    file: '.git/',
    mistakes: ["Running it inside an already-tracked folder (harmless — it just reinitializes)", 'Forgetting to run it before any other git command'],
    quiz: {
      q: 'What does "git init" actually create?',
      options: [
        { t: 'A remote repository on GitHub', correct: false },
        { t: 'A hidden .git folder that stores your project history', correct: true },
        { t: 'A backup copy of all your files', correct: false },
      ],
    },
  },
  {
    id: 'status',
    cmd: 'git status',
    blurb: 'Shows what has changed: which files are staged, which are untracked, and what branch you are on.',
    syntax: 'git status',
    example: 'git status',
    from: '',
    to: '',
    file: '',
    mistakes: ['Assuming it modifies anything — status is always read-only'],
    quiz: {
      q: 'Does "git status" change your files or history?',
      options: [
        { t: 'No — it only reports the current state', correct: true },
        { t: 'Yes — it stages all changes', correct: false },
        { t: 'Yes — it creates a commit', correct: false },
      ],
    },
  },
  {
    id: 'add',
    cmd: 'git add',
    blurb: 'Moves a file from your working directory into the staging area, marking it ready for the next commit.',
    syntax: 'git add <file>',
    example: 'git add index.html',
    from: 'workspace camp',
    to: 'staging backpack',
    file: 'index.html',
    mistakes: ['Forgetting to add a file and wondering why "git commit" says there is nothing to commit', 'Typing the wrong filename'],
    quiz: {
      q: 'After "git add file.txt", where does file.txt live?',
      options: [
        { t: 'It is deleted from the working directory', correct: false },
        { t: 'It is staged, ready for the next commit', correct: true },
        { t: 'It is already committed', correct: false },
      ],
    },
  },
  {
    id: 'commit',
    cmd: 'git commit',
    blurb: 'Takes everything in the staging area and saves it as a permanent snapshot in your project history.',
    syntax: 'git commit -m "message"',
    example: 'git commit -m "Add homepage"',
    from: 'staging backpack',
    to: 'commit history',
    file: 'index.html',
    mistakes: ['Forgetting the -m message flag', 'Committing with nothing staged'],
    quiz: {
      q: 'What do you need before "git commit" will succeed?',
      options: [
        { t: 'At least one staged file', correct: true },
        { t: 'An internet connection', correct: false },
        { t: 'A GitHub account', correct: false },
      ],
    },
  },
  {
    id: 'log',
    cmd: 'git log',
    blurb: 'Walks backward through commit history from HEAD, showing each commit and its message.',
    syntax: 'git log',
    example: 'git log',
    from: '',
    to: '',
    file: '',
    mistakes: ['Expecting it to show uncommitted changes — it only shows committed history'],
    quiz: {
      q: 'What does "git log" show?',
      options: [
        { t: 'Uncommitted changes in your working directory', correct: false },
        { t: 'The history of commits, newest first', correct: true },
        { t: 'A list of all branches', correct: false },
      ],
    },
  },
  {
    id: 'branch',
    cmd: 'git branch',
    blurb: 'Creates a new pointer at your current commit — an independent line of work that starts exactly where you are.',
    syntax: 'git branch <name>',
    example: 'git branch feature-ui',
    from: 'main',
    to: 'main + feature-ui pointer',
    file: 'feature-ui',
    mistakes: ['Expecting it to switch you onto the new branch too — it only creates it'],
    quiz: {
      q: 'Does "git branch feature-ui" move you onto that branch?',
      options: [
        { t: 'Yes, automatically', correct: false },
        { t: 'No — it only creates the pointer; you still need to switch', correct: true },
        { t: 'Only if there are no commits yet', correct: false },
      ],
    },
  },
  {
    id: 'checkout',
    cmd: 'git checkout',
    blurb: 'Moves HEAD to point at a different branch, so your working directory reflects that branch\'s files.',
    syntax: 'git checkout <name>',
    example: 'git checkout feature-ui',
    from: 'on main',
    to: 'on feature-ui',
    file: 'HEAD',
    mistakes: ['Trying to checkout a branch that does not exist yet (use -b to create it)'],
    quiz: {
      q: 'What does "git checkout -b new-thing" do?',
      options: [
        { t: 'Deletes the current branch', correct: false },
        { t: 'Creates "new-thing" and switches to it in one step', correct: true },
        { t: 'Merges new-thing into main', correct: false },
      ],
    },
  },
  {
    id: 'merge',
    cmd: 'git merge',
    blurb: 'Combines another branch into your current one — either by fast-forwarding, or with a two-parent merge commit.',
    syntax: 'git merge <name>',
    example: 'git merge feature-ui',
    from: 'two branches',
    to: 'one combined history',
    file: 'main',
    mistakes: ['Merging while on the wrong branch — check "git status" first', 'Panicking at a conflict instead of resolving it'],
    quiz: {
      q: "When does a merge create a new 'merge commit'?",
      options: [
        { t: 'Always', correct: false },
        { t: 'Only when both branches have new commits since they diverged', correct: true },
        { t: 'Never — merges never create commits', correct: false },
      ],
    },
  },
  {
    id: 'diff',
    cmd: 'git diff',
    blurb: 'Shows the exact line-by-line changes between your working directory and what is staged or committed.',
    syntax: 'git diff',
    example: 'git diff',
    from: '',
    to: '',
    file: '',
    mistakes: ['Forgetting --staged when you want to see staged (not working-tree) changes'],
    quiz: {
      q: 'What does plain "git diff" compare?',
      options: [
        { t: 'Working directory vs staging area', correct: true },
        { t: 'Two different branches', correct: false },
        { t: 'Local vs remote repository', correct: false },
      ],
    },
  },
];
