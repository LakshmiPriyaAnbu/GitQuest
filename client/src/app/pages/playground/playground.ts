import { Component, ElementRef, effect, inject, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Icon } from '../../shared/icon/icon';
import { PlaygroundFacade } from './playground.facade';

@Component({
  selector: 'gq-playground',
  imports: [Icon, FormsModule],
  templateUrl: './playground.html',
  styleUrl: './playground.css',
  providers: [PlaygroundFacade],
})
export class Playground {
  protected readonly vm = inject(PlaygroundFacade);

  private readonly termEl = viewChild<ElementRef<HTMLDivElement>>('termBody');

  constructor() {
    effect(() => {
      this.vm.attachTerminal(this.termEl()?.nativeElement);
    });
  }
}
