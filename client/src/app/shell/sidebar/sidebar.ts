import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { NAV_GROUPS } from '../../core/nav-data';
import { Icon } from '../../shared/icon/icon';

@Component({
  selector: 'gq-sidebar',
  imports: [RouterLink, RouterLinkActive, Icon],
  templateUrl: './sidebar.html',
  styleUrl: './sidebar.css',
})
export class Sidebar {
  protected readonly game = inject(GameStateService);
  protected readonly groups = NAV_GROUPS;
}
