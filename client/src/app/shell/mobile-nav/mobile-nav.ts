import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { MOBILE_NAV } from '../../core/nav-data';
import { Icon } from '../../shared/icon/icon';

@Component({
  selector: 'gq-mobile-nav',
  imports: [RouterLink, RouterLinkActive, Icon],
  templateUrl: './mobile-nav.html',
  styleUrl: './mobile-nav.css',
})
export class MobileNav {
  protected readonly items = MOBILE_NAV;
}
