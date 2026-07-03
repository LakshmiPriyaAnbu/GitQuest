import { Component, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { Icon } from '../../shared/icon/icon';
import { Mascot } from '../../shared/mascot/mascot';
import { DashboardFacade } from './dashboard.facade';

@Component({
  selector: 'gq-dashboard',
  imports: [Icon, Mascot, RouterLink],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.css',
  providers: [DashboardFacade],
})
export class Dashboard {
  protected readonly vm = inject(DashboardFacade);
}
