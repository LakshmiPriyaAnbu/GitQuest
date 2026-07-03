import { computed, inject, Injectable, signal } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { APP_CONTENT, LESSONS, QuizOption } from '../../generated/app-content';

@Injectable()
export class CommandLabFacade {
  private readonly game = inject(GameStateService);

  readonly copy = APP_CONTENT.commandLab;
  readonly lessons = LESSONS;
  readonly activeId = signal(LESSONS[0].id);
  readonly quizDone = signal<Record<string, boolean>>({});
  readonly wrongPick = signal<string | null>(null);

  readonly active = computed(() => this.lessons.find((lesson) => lesson.id === this.activeId()) ?? this.lessons[0]);
  readonly hasMove = computed(() => !!this.active().from);

  select(id: string) {
    this.activeId.set(id);
    this.wrongPick.set(null);
  }

  answer(option: QuizOption) {
    const lessonId = this.activeId();
    if (this.quizDone()[lessonId]) return;
    if (option.correct) {
      this.quizDone.update((state) => ({ ...state, [lessonId]: true }));
      this.wrongPick.set(null);
      this.game.award(15, this.copy.quizAwardReason);
    } else {
      this.wrongPick.set(option.t);
    }
  }
}
