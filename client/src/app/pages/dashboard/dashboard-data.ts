export interface FeatureCard {
  icon: string;
  iconBg: string;
  title: string;
  body: string;
  route: string;
}

export const FEATURES: FeatureCard[] = [
  { icon: 'play', iconBg: '#43E197', title: 'Git Playground', body: 'Type real commands and watch your files move between camp, backpack, and commits.', route: '/playground' },
  { icon: 'lab', iconBg: '#FFC24B', title: 'Command Lab', body: 'Learn one git spell at a time, with a quiz to prove you’ve got it.', route: '/commandlab' },
  { icon: 'map', iconBg: '#9B7CFF', title: 'Commit Map', body: 'See your whole history as a branching quest map you can click through.', route: '/commitmap' },
  { icon: 'branch', iconBg: '#37D6E6', title: 'Branch & Merge', body: 'Fork a path, fight a merge conflict, and bring it all back together.', route: '/branches' },
  { icon: 'quest', iconBg: '#FF6B9D', title: 'Quests', body: 'A guided path of 8 quests that takes you from init to your first merge.', route: '/quests' },
];
