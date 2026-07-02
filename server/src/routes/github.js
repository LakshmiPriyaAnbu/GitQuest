import { Router } from 'express';

const router = Router();
const GH = 'https://api.github.com';
const headers = { Accept: 'application/vnd.github+json', 'User-Agent': 'gitquest-app' };

router.get('/:username', async (req, res) => {
  const username = req.params.username;
  try {
    const profileRes = await fetch(`${GH}/users/${encodeURIComponent(username)}`, { headers });
    if (profileRes.status === 404) {
      return res.status(404).json({ error: 'not_found', message: 'No GitHub profile found.' });
    }
    if (!profileRes.ok) {
      return res.status(502).json({
        error: 'upstream_error',
        message: "GitHub's API is rate-limiting us right now. Try the demo profile instead.",
      });
    }
    const [user, repos, events] = await Promise.all([
      profileRes.json(),
      fetch(`${GH}/users/${encodeURIComponent(username)}/repos?per_page=100&sort=updated`, { headers }).then((r) =>
        r.ok ? r.json() : []
      ),
      fetch(`${GH}/users/${encodeURIComponent(username)}/events/public?per_page=100`, { headers }).then((r) =>
        r.ok ? r.json() : []
      ),
    ]);
    res.json({ user, repos, events });
  } catch (err) {
    res.status(502).json({ error: 'upstream_error', message: 'Could not reach GitHub. Try the demo profile instead.' });
  }
});

export default router;
