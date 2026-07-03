import { Component, inject } from '@angular/core';
import { GameStateService } from '../../core/game-state.service';
import { ViewportService } from '../../core/viewport.service';
import { ShellStateService } from '../shell-state.service';

@Component({
  selector: 'gq-header',
  templateUrl: './header.html',
  styleUrl: './header.css',
})
export class Header {
  protected readonly game = inject(GameStateService);
  protected readonly viewport = inject(ViewportService);
  protected readonly shell = inject(ShellStateService);
}
