import { GhEvent, GhRepo, GithubBundle } from './models';

const DEMO_REPOS: GhRepo[] = [
  { name: 'MiniRedis-Visualizer', language: 'TypeScript', stargazers_count: 42, html_url: '#' },
  { name: 'SpendWise', language: 'Swift', stargazers_count: 18, html_url: '#' },
  { name: 'GitQuest', language: 'TypeScript', stargazers_count: 27, html_url: '#' },
  { name: 'Alexa-APL-UI', language: 'JavaScript', stargazers_count: 9, html_url: '#' },
  { name: 'c-allocator', language: 'C', stargazers_count: 5, html_url: '#' },
];

const EVENT_CYCLE = ['PushEvent', 'PushEvent', 'PushEvent', 'PullRequestEvent', 'IssuesEvent', 'WatchEvent', 'CreateEvent'];

export function buildDemoBundle(): GithubBundle {
  const now = Date.now();
  const events: GhEvent[] = [];
  for (let i = 0; i < 120; i++) {
    const daysAgo = Math.pow(Math.random(), 1.6) * 38;
    const created = new Date(now - daysAgo * 86400000);
    const repo = DEMO_REPOS[i % DEMO_REPOS.length];
    events.push({
      type: EVENT_CYCLE[i % EVENT_CYCLE.length],
      created_at: created.toISOString(),
      repo: { name: `dev-priya/${repo.name}` },
    });
  }
  events.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

  return {
    user: {
      login: 'dev-priya',
      name: 'Priya (demo)',
      bio: 'Building playful developer tools.',
      public_repos: DEMO_REPOS.length,
      followers: 58,
      following: 31,
    },
    repos: DEMO_REPOS,
    events,
    demo: true,
  };
}
