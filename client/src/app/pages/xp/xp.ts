import { Component, computed, inject } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { GithubService } from '../../core/github.service';
import { BADGES } from '../../core/game-data';
import { deriveGithubStats } from '../../core/github-derived';

const DAY_NAMES = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const LIVE_BADGE_IDS = new Set(['streak', 'repo', 'pr', 'bughunter']);

@Component({
  selector: 'gq-xp',
  templateUrl: './xp.html',
  styleUrl: './xp.css',
})
export class Xp {
  protected readonly game = inject(GameStateService);
  protected readonly git = inject(GitApiService);
  protected readonly github = inject(GithubService);

  private readonly derived = computed(() => {
    const data = this.github.data();
    return data ? deriveGithubStats(data) : null;
  });

  protected readonly badges = computed(() => {
    const persisted = this.game.badges();
    const derived = this.derived();
    return BADGES.map((b) => {
      const unlocked = LIVE_BADGE_IDS.has(b.id) ? !!derived?.badges[b.id as keyof typeof derived.badges] : !!persisted[b.id];
      return { ...b, unlocked };
    });
  });

  protected readonly weeklyBars = computed(() => {
    const derived = this.derived();
    if (derived) {
      return derived.weeklyActivity.map((d) => ({ day: d.day, pct: d.pct, count: d.count }));
    }
    const historyLen = this.git.state()?.history.length ?? 0;
    const active = Math.min(7, historyLen);
    return DAY_NAMES.map((day, i) => ({
      day,
      pct: i < active ? 24 + ((i * 13) % 64) : 8,
      count: i < active ? 1 : 0,
    }));
  });

  protected readonly hasGithubData = computed(() => !!this.derived());

  protected readonly unlockedBadgeCount = computed(() => this.badges().filter((b) => b.unlocked).length);
}
