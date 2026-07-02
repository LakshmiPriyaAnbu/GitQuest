import { Component, computed, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { GithubService } from '../../core/github.service';

@Component({
  selector: 'gq-settings',
  imports: [FormsModule],
  templateUrl: './settings.html',
  styleUrl: './settings.css',
})
export class Settings {
  protected readonly game = inject(GameStateService);
  protected readonly git = inject(GitApiService);
  protected readonly github = inject(GithubService);

  protected readonly badgeCount = computed(() => Object.keys(this.game.badges()).length);

  setTheme(theme: 'nebula' | 'candy') {
    this.game.updateSettings({ theme });
  }

  setAnimSpeed(value: string) {
    this.game.updateSettings({ animSpeed: Number(value) });
  }

  toggleCacheUser(checked: boolean) {
    this.game.updateSettings({ cacheUser: checked });
    if (!checked) this.github.clearCache();
  }

  resetPlayground() {
    this.git.reset().subscribe();
  }

  exportSummary() {
    const state = this.git.state();
    const summary = {
      app: 'GitQuest',
      generated: new Date().toISOString(),
      xp: this.game.xp(),
      level: this.game.levelInfo().level,
      questsCompleted: Object.keys(this.game.quests()),
      badges: Object.keys(this.game.badges()),
      commits: state?.order.length ?? 0,
      branches: state ? Object.keys(state.branches) : [],
    };
    const blob = new Blob([JSON.stringify(summary, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'gitquest-summary.json';
    a.click();
    URL.revokeObjectURL(url);
  }
}
