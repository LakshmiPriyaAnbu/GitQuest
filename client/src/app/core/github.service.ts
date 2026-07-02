import { HttpClient } from '@angular/common/http';
import { Injectable, inject, signal } from '@angular/core';
import { GameStateService } from './game-state.service';
import { buildDemoBundle } from './github-demo';
import { GhEvent, GhRepo, GhUser, GithubBundle } from './models';

const CACHE_KEY = 'gitquest_user';

@Injectable({ providedIn: 'root' })
export class GithubService {
  private http = inject(HttpClient);
  private game = inject(GameStateService);

  readonly status = signal<'empty' | 'loading' | 'error' | 'loaded'>('empty');
  readonly data = signal<GithubBundle | null>(null);
  readonly errorMessage = signal('');

  constructor() {
    if (this.game.settings().cacheUser) {
      const cached = localStorage.getItem(CACHE_KEY);
      if (cached) this.load(cached);
    }
  }

  load(username: string) {
    this.status.set('loading');
    this.http.get<{ user: GhUser; repos: GhRepo[]; events: GhEvent[] }>(`/api/github/${encodeURIComponent(username)}`).subscribe({
      next: (res) => {
        this.data.set({ ...res, demo: false });
        this.status.set('loaded');
        if (this.game.settings().cacheUser) localStorage.setItem(CACHE_KEY, username);
        this.game.unlock('oss', 'Open Source Adventurer');
        this.game.award(20, 'Scanned a GitHub profile');
      },
      error: (err) => {
        this.status.set('error');
        this.errorMessage.set(err?.error?.message || 'Something went wrong reaching GitHub.');
      },
    });
  }

  loadDemo() {
    this.data.set(buildDemoBundle());
    this.status.set('loaded');
    this.errorMessage.set('');
  }

  clearCache() {
    localStorage.removeItem(CACHE_KEY);
  }
}
