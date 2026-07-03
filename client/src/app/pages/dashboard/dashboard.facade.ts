import { computed, inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { APP_CONTENT, FEATURES, QUESTS } from '../../generated/app-content';

@Injectable()
export class DashboardFacade {
  private readonly router = inject(Router);
  private readonly game = inject(GameStateService);
  private readonly git = inject(GitApiService);

  readonly copy = APP_CONTENT.dashboard;
  readonly features = FEATURES;

  readonly stats = computed(() => {
    const state = this.git.state();
    const commits = state ? state.order.length : 0;
    const branches = state ? Object.keys(state.branches).length : 0;
    const values: Record<string, string> = {
      commits: String(commits),
      branches: String(branches),
      quests: `${this.game.questsDone()}/${QUESTS.length}`,
      badges: `${Object.keys(this.game.badges()).length}/${APP_CONTENT.badges.length}`,
    };
    return this.copy.stats.map((stat) => ({
      ...stat,
      value: values[stat.id] ?? '0',
      className: `stat-palette-${stat.palette}`,
    }));
  });

  openPlayground() {
    this.router.navigateByUrl('/playground');
  }

  openGithub() {
    this.router.navigateByUrl('/github');
  }
}
