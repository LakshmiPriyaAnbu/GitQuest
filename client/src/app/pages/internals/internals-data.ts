export interface ConceptCard {
  emoji: string;
  title: string;
  meta: string;
  body: string;
  accent: string;
}

export const INTERNALS_CARDS: ConceptCard[] = [
  { emoji: '🩸', title: 'Blob', meta: 'file crystal', body: 'The raw content of a file, stored by its content hash — rename the file and the blob stays exactly the same.', accent: '#FF6B9D' },
  { emoji: '🌳', title: 'Tree', meta: 'folder snapshot', body: "A directory listing that points at blobs and other trees, capturing your project's shape at one moment in time.", accent: '#43E197' },
  { emoji: '💎', title: 'Commit', meta: 'commit crystal', body: 'A snapshot pointer: one tree, a message, an author, and links back to its parent commit(s).', accent: '#9B7CFF' },
  { emoji: '#️⃣', title: 'SHA hash', meta: 'unique fingerprint', body: "A 40-character hash of an object's content — change a single byte and the SHA changes completely.", accent: '#FFC24B' },
  { emoji: '🚩', title: 'HEAD', meta: 'you are here', body: 'A pointer to whichever commit or branch you currently have checked out.', accent: '#37D6E6' },
  { emoji: '🌿', title: 'Branch ref', meta: 'movable signpost', body: 'Just a small file holding a commit SHA — creating a branch is nearly instant because it copies nothing.', accent: '#FF8A4C' },
  { emoji: '🎒', title: 'The Index', meta: 'staging backpack', body: 'Also called the staging area — a holding zone where you build up exactly what the next commit will contain.', accent: '#43E197' },
  { emoji: '🗄️', title: 'Object DB', meta: 'the vault', body: 'The .git/objects folder — a content-addressed store holding every blob, tree, and commit you have ever made.', accent: '#9B7CFF' },
];
