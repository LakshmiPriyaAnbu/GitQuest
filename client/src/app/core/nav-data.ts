export interface NavItem {
  route: string;
  label: string;
  icon: string;
}

export interface NavGroup {
  title: string;
  items: NavItem[];
}

export const NAV_GROUPS: NavGroup[] = [
  {
    title: 'PLAY',
    items: [
      { route: '/dashboard', label: 'Home', icon: 'home' },
      { route: '/playground', label: 'Git Playground', icon: 'play' },
      { route: '/commandlab', label: 'Command Lab', icon: 'lab' },
    ],
  },
  {
    title: 'VISUALIZE',
    items: [
      { route: '/commitmap', label: 'Commit Map', icon: 'map' },
      { route: '/branches', label: 'Branch & Merge', icon: 'branch' },
      { route: '/internals', label: 'Git Internals', icon: 'internals' },
    ],
  },
  {
    title: 'YOUR PROFILE',
    items: [
      { route: '/github', label: 'GitHub Activity', icon: 'github' },
      { route: '/xp', label: 'XP Dashboard', icon: 'xp' },
      { route: '/quests', label: 'Quests', icon: 'quest' },
    ],
  },
  {
    title: 'LEARN',
    items: [
      { route: '/learn', label: 'Concepts', icon: 'learn' },
      { route: '/settings', label: 'Settings', icon: 'settings' },
    ],
  },
];

export const MOBILE_NAV: NavItem[] = [
  { route: '/dashboard', label: 'Home', icon: 'home' },
  { route: '/playground', label: 'Play', icon: 'play' },
  { route: '/commitmap', label: 'Map', icon: 'map' },
  { route: '/github', label: 'GitHub', icon: 'github' },
  { route: '/quests', label: 'Quests', icon: 'quest' },
];

export const ROUTE_META: Record<string, { title: string; sub: string }> = {
  '/dashboard': { title: 'Welcome, adventurer', sub: 'your git journey starts here' },
  '/playground': { title: 'Git Playground', sub: 'type commands, watch the world change' },
  '/commandlab': { title: 'Command Lab', sub: 'learn one spell at a time' },
  '/commitmap': { title: 'Commit Map', sub: 'your history as a quest map' },
  '/branches': { title: 'Branch & Merge', sub: 'fork paths and bring them back together' },
  '/internals': { title: 'Git Internals', sub: 'what git hides under the hood' },
  '/learn': { title: 'Learn', sub: 'plain-English git concepts' },
  '/github': { title: 'GitHub Visualizer', sub: 'turn a profile into a quest log' },
  '/xp': { title: 'XP Dashboard', sub: 'your developer power level' },
  '/quests': { title: 'Quests', sub: 'the guided learning path' },
  '/settings': { title: 'Settings', sub: 'tune your playground' },
};
