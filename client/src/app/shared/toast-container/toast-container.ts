import { Component, inject } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { Icon } from '../icon/icon';
import { ToastKind } from '../../core/models';

const KIND_STYLE: Record<ToastKind, { bg: string; icon: string; fg: string }> = {
  xp: { bg: '#FFC24B', icon: 'xp', fg: '#5B3D06' },
  badge: { bg: '#FF6B9D', icon: 'trophy', fg: '#FFF4E4' },
  info: { bg: '#37D6E6', icon: 'flag', fg: '#0B3A40' },
};

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

  style(kind: ToastKind) {
    return KIND_STYLE[kind];
  }
}
