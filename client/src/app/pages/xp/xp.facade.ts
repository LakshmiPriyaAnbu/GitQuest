import { computed, inject, Injectable } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { GithubService } from '../../core/github.service';
import { BADGES, APP_CONTENT, type XpCopy } from '../../generated/app-content';
import { deriveGithubStats } from '../../core/github-derived';

const LIVE_BADGE_IDS = new Set(['streak', 'repo', 'pr', 'bughunter']);

@Injectable()
export class XpFacade {
  private readonly game = inject(GameStateService);
  private readonly git = inject(GitApiService);
  private readonly github = inject(GithubService);

  readonly copy: XpCopy = APP_CONTENT.xp;

  private readonly derived = computed(() => {
    const data = this.github.data();
    return data ? deriveGithubStats(data) : null;
  });

  readonly badges = computed(() => {
    const persisted = this.game.badges();
    const derived = this.derived();
    return BADGES.map((badge) => {
      const unlocked = LIVE_BADGE_IDS.has(badge.id) ? !!derived?.badges[badge.id as keyof typeof derived.badges] : !!persisted[badge.id];
      return { ...badge, unlocked };
    });
  });

  readonly weeklyBars = computed(() => {
    const derived = this.derived();
    if (derived) {
      return derived.weeklyActivity.map((day) => ({ day: day.day, pct: day.pct, count: day.count }));
    }
    const historyLen = this.git.state()?.history.length ?? 0;
    const active = Math.min(7, historyLen);
    return this.copy.dayNames.map((day: string, index: number) => ({
      day,
      pct: index < active ? 24 + ((index * 13) % 64) : 8,
      count: index < active ? 1 : 0,
    }));
  });

  readonly hasGithubData = computed(() => !!this.derived());
  readonly unlockedBadgeCount = computed(() => this.badges().filter((badge) => badge.unlocked).length);
  readonly stats = computed(() => {
    const values: Record<string, string> = {
      xp: String(this.game.xp()),
      rank: this.game.levelInfo().title,
      quests: `${this.game.questsDone()}/${APP_CONTENT.quests.items.length}`,
      badges: `${this.unlockedBadgeCount()}/${BADGES.length}`,
    };
    return this.copy.stats.map((stat) => ({
      ...stat,
      value: values[stat.id] ?? '0',
      className: `stat-palette-${stat.palette}`,
    }));
  });
}
