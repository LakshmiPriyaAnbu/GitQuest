import { ConceptCard } from '../internals/internals-data';

export const LEARN_CARDS: ConceptCard[] = [
  { emoji: '⛺', title: 'Working Directory', meta: 'your workspace camp', body: 'The actual files on your disk that you are editing right now.', accent: '#37D6E6' },
  { emoji: '🎒', title: 'Staging Area', meta: 'the backpack', body: 'Where you gather changes before committing them — like packing a bag before a trip.', accent: '#FFC24B' },
  { emoji: '📚', title: 'Repository', meta: 'the whole story', body: 'The full history of your project, stored in the hidden .git folder.', accent: '#9B7CFF' },
  { emoji: '💎', title: 'Commit', meta: 'a saved checkpoint', body: 'A saved checkpoint of your project — you can always come back to it later.', accent: '#43E197' },
  { emoji: '🌿', title: 'Branch', meta: 'a forked path', body: 'An independent line of work, so you can experiment without touching the main line.', accent: '#FF8A4C' },
  { emoji: '🚩', title: 'HEAD', meta: 'you are here', body: "A marker for 'where you are right now' in your project's history.", accent: '#FF6B9D' },
  { emoji: '🔀', title: 'Merge', meta: 'weaving paths together', body: 'Combining changes from two branches back into one.', accent: '#37D6E6' },
  { emoji: '⚔️', title: 'Conflict', meta: 'a boss battle', body: 'When two branches changed the same lines and Git needs you to pick a winner.', accent: '#FF6B9D' },
  { emoji: '🌐', title: 'Remote vs Local', meta: 'two copies', body: 'Local is the copy on your machine; remote is the copy hosted elsewhere, like GitHub.', accent: '#9B7CFF' },
  { emoji: '🐙', title: 'Git vs GitHub', meta: "they're not the same!", body: 'Git is the version control tool; GitHub is a website that hosts Git repositories and adds collaboration features.', accent: '#FFC24B' },
];
