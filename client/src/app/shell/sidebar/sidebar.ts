import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { Icon } from '../../shared/icon/icon';
import { ShellStateService } from '../shell-state.service';

@Component({
  selector: 'gq-sidebar',
  imports: [RouterLink, RouterLinkActive, Icon],
  templateUrl: './sidebar.html',
  styleUrl: './sidebar.css',
})
export class Sidebar {
  protected readonly game = inject(GameStateService);
  protected readonly shell = inject(ShellStateService);
}
