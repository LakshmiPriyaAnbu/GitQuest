import { computed, inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { APP_CONTENT, QUESTS } from '../../generated/app-content';

@Injectable()
export class QuestsFacade {
  private readonly router = inject(Router);
  private readonly game = inject(GameStateService);

  readonly copy = APP_CONTENT.quests;

  readonly rows = computed(() => {
    const done = this.game.quests();
    let prevDone = true;
    return QUESTS.map((quest) => {
      const isDone = !!done[quest.id];
      const available = prevDone && !isDone;
      const locked = !prevDone && !isDone;
      prevDone = isDone;
      return {
        ...quest,
        isDone,
        available,
        locked,
        difficultyClass: `quest-diff-${quest.difficulty.toLowerCase()}`,
        statusLabel: isDone ? this.copy.statusDone : available ? this.copy.statusAvailable : this.copy.statusLocked,
        ctaLabel: isDone ? this.copy.replayButton : this.copy.startButton,
      };
    });
  });

  start(route: string) {
    this.router.navigateByUrl(route);
  }
}
