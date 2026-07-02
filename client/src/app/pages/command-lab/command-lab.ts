import { Component, computed, inject, signal } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { Icon } from '../../shared/icon/icon';
import { LESSONS, QuizOption } from './command-lab-data';

@Component({
  selector: 'gq-command-lab',
  imports: [Icon],
  templateUrl: './command-lab.html',
  styleUrl: './command-lab.css',
})
export class CommandLab {
  private readonly game = inject(GameStateService);

  protected readonly lessons = LESSONS;
  protected readonly activeId = signal(LESSONS[0].id);
  protected readonly quizDone = signal<Record<string, boolean>>({});
  protected readonly wrongPick = signal<string | null>(null);

  protected readonly active = computed(() => this.lessons.find((l) => l.id === this.activeId())!);
  protected readonly hasMove = computed(() => !!this.active().from);

  select(id: string) {
    this.activeId.set(id);
    this.wrongPick.set(null);
  }

  answer(opt: QuizOption) {
    const id = this.activeId();
    if (this.quizDone()[id]) return;
    if (opt.correct) {
      this.quizDone.update((d) => ({ ...d, [id]: true }));
      this.wrongPick.set(null);
      this.game.award(15, 'Lesson quiz cleared');
    } else {
      this.wrongPick.set(opt.t);
    }
  }
}
