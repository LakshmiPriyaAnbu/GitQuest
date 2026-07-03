import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { Icon } from '../../shared/icon/icon';
import { ShellStateService } from '../shell-state.service';

@Component({
  selector: 'gq-mobile-nav',
  imports: [RouterLink, RouterLinkActive, Icon],
  templateUrl: './mobile-nav.html',
  styleUrl: './mobile-nav.css',
})
export class MobileNav {
  protected readonly shell = inject(ShellStateService);
}
