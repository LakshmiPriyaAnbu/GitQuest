import { GithubBundle } from './models';

export interface HeatmapCell {
  date: string;
  count: number;
  color: string;
}

export interface DerivedGithub {
  languages: { name: string; pct: number }[];
  topRepos: { name: string; stars: number; url: string }[];
  totalStars: number;
  weeks: HeatmapCell[][];
  longestStreak: number;
  currentStreak: number;
  totalContributions: number;
  weeklyActivity: { day: string; pct: number; count: number }[];
  badges: { streak: boolean; repo: boolean; pr: boolean; bughunter: boolean };
  recent: { icon: string; text: string; when: string }[];
}

const DAY_NAMES = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

const EVENT_VERB: Record<string, [string, string]> = {
  PushEvent: ['⬆️', 'pushed to'],
  CreateEvent: ['✨', 'created'],
  PullRequestEvent: ['🎯', 'opened a PR in'],
  IssuesEvent: ['🐛', 'opened an issue in'],
  WatchEvent: ['⭐', 'starred'],
  ForkEvent: ['🍴', 'forked'],
  DeleteEvent: ['🗑️', 'cleaned up'],
  PullRequestReviewEvent: ['👀', 'reviewed in'],
  IssueCommentEvent: ['💬', 'commented in'],
};

function cellColor(count: number): string {
  if (count === 0) return '#2E2560';
  if (count < 2) return '#2f7d57';
  if (count < 4) return '#37b377';
  return '#43E197';
}

function dayKey(d: Date): string {
  return d.toISOString().slice(0, 10);
}

export function deriveGithubStats(bundle: GithubBundle): DerivedGithub {
  const { repos, events } = bundle;

  const langCounts = new Map<string, number>();
  for (const r of repos) {
    if (!r.language) continue;
    langCounts.set(r.language, (langCounts.get(r.language) ?? 0) + 1);
  }
  const totalLang = [...langCounts.values()].reduce((a, b) => a + b, 0) || 1;
  const languages = [...langCounts.entries()]
    .map(([name, n]) => ({ name, pct: Math.max(6, Math.round((n / totalLang) * 100)) }))
    .sort((a, b) => b.pct - a.pct)
    .slice(0, 5);

  const topRepos = [...repos]
    .sort((a, b) => b.stargazers_count - a.stargazers_count)
    .slice(0, 4)
    .map((r) => ({ name: r.name, stars: r.stargazers_count, url: r.html_url }));
  const totalStars = repos.reduce((sum, r) => sum + r.stargazers_count, 0);

  const countsByDay = new Map<string, number>();
  for (const e of events) {
    const key = dayKey(new Date(e.created_at));
    countsByDay.set(key, (countsByDay.get(key) ?? 0) + 1);
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const totalDays = 19 * 7;
  const days: HeatmapCell[] = [];
  for (let i = totalDays - 1; i >= 0; i--) {
    const d = new Date(today.getTime() - i * 86400000);
    const key = dayKey(d);
    const count = countsByDay.get(key) ?? 0;
    days.push({ date: key, count, color: cellColor(count) });
  }
  const weeks: HeatmapCell[][] = [];
  for (let w = 0; w < 19; w++) weeks.push(days.slice(w * 7, w * 7 + 7));

  let longestStreak = 0;
  let running = 0;
  for (const d of days) {
    if (d.count > 0) {
      running++;
      longestStreak = Math.max(longestStreak, running);
    } else {
      running = 0;
    }
  }
  let currentStreak = 0;
  for (let i = days.length - 1; i >= 0; i--) {
    if (days[i].count > 0) currentStreak++;
    else break;
  }

  const totalContributions = events.length;

  const byDow = new Array(7).fill(0);
  for (const e of events) byDow[new Date(e.created_at).getDay()]++;
  const maxDow = Math.max(1, ...byDow);
  const weeklyActivity = DAY_NAMES.map((day, i) => ({
    day,
    count: byDow[i],
    pct: Math.round((byDow[i] / maxDow) * 100),
  }));

  const hasPr = events.some((e) => e.type === 'PullRequestEvent');
  const hasIssue = events.some((e) => e.type === 'IssuesEvent');
  const badges = {
    streak: currentStreak >= 7,
    repo: repos.length >= 3,
    pr: hasPr,
    bughunter: hasIssue,
  };

  const recent = events.slice(0, 8).map((e) => {
    const [icon, verb] = EVENT_VERB[e.type] ?? ['📌', 'did something in'];
    const repoName = e.repo?.name?.split('/').pop() ?? e.repo?.name ?? 'a repo';
    return { icon, text: `${verb} ${repoName}`, when: timeAgo(new Date(e.created_at)) };
  });

  return { languages, topRepos, totalStars, weeks, longestStreak, currentStreak, totalContributions, weeklyActivity, badges, recent };
}

function timeAgo(date: Date): string {
  const seconds = Math.max(1, Math.round((Date.now() - date.getTime()) / 1000));
  const units: [number, string][] = [
    [31536000, 'y'],
    [2592000, 'mo'],
    [86400, 'd'],
    [3600, 'h'],
    [60, 'm'],
  ];
  for (const [secs, label] of units) {
    if (seconds >= secs) return `${Math.floor(seconds / secs)}${label} ago`;
  }
  return 'just now';
}
