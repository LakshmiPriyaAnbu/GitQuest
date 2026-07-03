import { Injectable, inject } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { APP_CONTENT, type SettingsCopy } from '../../generated/app-content';

@Injectable()
export class SettingsExportService {
  private readonly game = inject(GameStateService);
  private readonly git = inject(GitApiService);
  private readonly settingsCopy: SettingsCopy = APP_CONTENT.settings;

  downloadSummary() {
    const state = this.git.state();
    const summary = {
      app: this.settingsCopy.exportAppName,
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
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = this.settingsCopy.exportFilename;
    anchor.click();
    URL.revokeObjectURL(url);
  }
}
