import express from 'express';
import session from 'express-session';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import gitRoutes from './routes/git.js';
import githubRoutes from './routes/github.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const clientDist = path.join(__dirname, '../../client/dist/client/browser');

const app = express();
const PORT = process.env.PORT || 3000;

app.set('trust proxy', 1);
app.get('/healthz', (req, res) => res.status(200).send('ok'));

app.use(express.json());
app.use(
  session({
    name: 'gitquest.sid',
    secret: process.env.SESSION_SECRET || 'gitquest-dev-secret',
    resave: false,
    saveUninitialized: true,
    cookie: { httpOnly: true, sameSite: 'lax', secure: process.env.NODE_ENV === 'production' },
  })
);

app.use('/api/git', gitRoutes);
app.use('/api/github', githubRoutes);

app.use(express.static(clientDist));
app.get(/^(?!\/api).*/, (req, res) => {
  res.sendFile(path.join(clientDist, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`GitQuest server listening on http://localhost:${PORT}`);
});
