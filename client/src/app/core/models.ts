export type TerminalLineKind = 'sys' | 'ok' | 'err' | 'dim' | 'plain';

export interface TerminalLine {
  k: TerminalLineKind;
  t: string;
}

export interface WorkingFile {
  name: string;
  state?: string;
}

export interface StagedFile {
  name: string;
}

export interface Commit {
  id: string;
  msg: string;
  parents: string[];
  files: string[];
  branch: string;
  time: number;
  author: string;
  isMerge?: boolean;
}

export interface Conflict {
  file: string;
  ours: string[];
  theirs: string[];
}

export interface GitState {
  initialized: boolean;
  workingDir: WorkingFile[];
  staging: StagedFile[];
  commits: Record<string, Commit>;
  order: string[];
  branches: Record<string, string | null>;
  head: { type: 'branch'; ref: string };
  history: string[];
  output: TerminalLine[];
  explain: { title: string; body: string };
  conflict: Conflict | null;
}

export type GameEvent =
  | { type: 'quest'; id: string; title: string; xp: number }
  | { type: 'badge'; id: string; title: string }
  | { type: 'xp'; amount: number; reason: string };

export interface GitCommandResponse {
  state: GitState;
  events: GameEvent[];
  message?: string;
}

export type ToastKind = 'xp' | 'badge' | 'info';

export interface Toast {
  id: number;
  title: string;
  body: string;
  kind: ToastKind;
  dur: number;
}

export interface QuestDef {
  id: string;
  title: string;
  difficulty: 'Easy' | 'Medium' | 'Hard';
  minutes: number;
  xp: number;
  hint: string;
  route: string;
}

export interface BadgeDef {
  id: string;
  emoji: string;
  title: string;
  hint: string;
}

export interface GhUser {
  login: string;
  name?: string;
  avatar_url?: string;
  bio?: string;
  public_repos: number;
  followers: number;
  following: number;
}

export interface GhRepo {
  name: string;
  language: string | null;
  stargazers_count: number;
  html_url: string;
}

export interface GhEvent {
  type: string;
  created_at: string;
  repo: { name: string };
}

export interface GithubBundle {
  user: GhUser;
  repos: GhRepo[];
  events: GhEvent[];
  demo?: boolean;
}
