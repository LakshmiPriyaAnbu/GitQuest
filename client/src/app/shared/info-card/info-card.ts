import { Component, input } from '@angular/core';

@Component({
  selector: 'gq-info-card',
  template: `
    <div class="info-card">
      <div class="info-card-badge" [style.background]="accent()">{{ emoji() }}</div>
      <div class="info-card-title">{{ title() }}</div>
      @if (subtitle()) {
        <div class="info-card-subtitle">{{ subtitle() }}</div>
      }
      <div class="info-card-body"><ng-content></ng-content></div>
    </div>
  `,
  styleUrl: './info-card.css',
})
export class InfoCard {
  readonly emoji = input('✦');
  readonly title = input('');
  readonly subtitle = input('');
  readonly accent = input('#9B7CFF');
}
