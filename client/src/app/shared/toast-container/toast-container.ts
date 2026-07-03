import { Component, inject } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { Icon } from '../icon/icon';
import { ToastKind } from '../../core/models';
import { ToastPresenterService } from './toast-presenter.service';

@Component({
  selector: 'gq-toast-container',
  imports: [Icon],
  template: `
    <div class="toast-stack">
      @for (t of game.toasts(); track t.id) {
        <div class="toast" [style.animationDuration.ms]="t.dur">
          <span class="toast-icon" [style.background]="style(t.kind).bg" [style.color]="style(t.kind).fg">
            <gq-icon [name]="style(t.kind).icon" [size]="16" [stroke]="style(t.kind).fg"></gq-icon>
          </span>
          <span class="toast-text">
            <span class="toast-title">{{ t.title }}</span>
            <span class="toast-body">{{ t.body }}</span>
          </span>
        </div>
      }
    </div>
  `,
  styleUrl: './toast-container.css',
})
export class ToastContainer {
  protected readonly game = inject(GameStateService);
  private readonly presenter = inject(ToastPresenterService);

  style(kind: ToastKind) {
    return this.presenter.style(kind);
  }
}
