import { DOCUMENT } from '@angular/common';
import { effect, inject, Injectable } from '@angular/core';
import { GameStateService } from './game-state.service';
import { APP_THEME } from '../generated/app-theme';

@Injectable({ providedIn: 'root' })
export class ThemeService {
  private readonly document = inject(DOCUMENT);
  private readonly game = inject(GameStateService);

  constructor() {
    effect(() => {
      const theme = this.game.settings().theme;
      const vars = APP_THEME.themes[theme].cssVars;
      const root = this.document.documentElement;
      for (const [key, value] of Object.entries(vars)) {
        root.style.setProperty(`--${key}`, value);
      }
    });
  }
}
