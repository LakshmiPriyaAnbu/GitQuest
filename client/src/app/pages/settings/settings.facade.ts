import { computed, inject, Injectable } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { GithubService } from '../../core/github.service';
import { APP_CONTENT, type SettingsCopy } from '../../generated/app-content';
import { SettingsExportService } from './settings-export.service';

@Injectable()
export class SettingsFacade {
  private readonly game = inject(GameStateService);
  private readonly git = inject(GitApiService);
  private readonly github = inject(GithubService);
  private readonly exporter = inject(SettingsExportService);

  readonly copy: SettingsCopy = APP_CONTENT.settings;
  readonly settings = this.game.settings;
  readonly badgeCount = computed(() => Object.keys(this.game.badges()).length);

  readonly aboutStats = computed(() => {
    const values: Record<string, string> = {
      xp: String(this.game.xp()),
      rank: this.game.levelInfo().title,
      quests: `${this.game.questsDone()}/${APP_CONTENT.quests.items.length}`,
      badges: `${this.badgeCount()}/${APP_CONTENT.badges.length}`,
    };
    return this.copy.about.map((item) => ({
      ...item,
      value: values[item.id] ?? '0',
    }));
  });

  setTheme(theme: string) {
    this.game.updateSettings({ theme: theme as 'nebula' | 'candy' });
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
    this.exporter.downloadSummary();
  }
}
