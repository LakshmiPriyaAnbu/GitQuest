import { Component, computed, inject } from '@angular/core';
import { Router } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { QUESTS } from '../../core/game-data';

const DIFFICULTY_COLOR: Record<string, string> = {
  Easy: '#43E197',
  Medium: '#FFC24B',
  Hard: '#FF6B9D',
};

@Component({
  selector: 'gq-quests',
  templateUrl: './quests.html',
  styleUrl: './quests.css',
})
export class Quests {
  private readonly router = inject(Router);
  protected readonly game = inject(GameStateService);

  protected readonly rows = computed(() => {
    const done = this.game.quests();
    let prevDone = true;
    return QUESTS.map((q) => {
      const isDone = !!done[q.id];
      const available = prevDone && !isDone;
      const locked = !prevDone && !isDone;
      prevDone = isDone;
      return { ...q, isDone, available, locked, color: DIFFICULTY_COLOR[q.difficulty] };
    });
  });

  start(route: string) {
    this.router.navigateByUrl(route);
  }
}
