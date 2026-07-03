import { Component, inject } from '@angular/core';
import { XpFacade } from './xp.facade';

@Component({
  selector: 'gq-xp',
  templateUrl: './xp.html',
  styleUrl: './xp.css',
  providers: [XpFacade],
})
export class Xp {
  protected readonly vm = inject(XpFacade);
}
