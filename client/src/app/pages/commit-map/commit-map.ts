import { Component, inject } from '@angular/core';
import { CommitMapFacade } from './commit-map.facade';

@Component({
  selector: 'gq-commit-map',
  templateUrl: './commit-map.html',
  styleUrl: './commit-map.css',
  providers: [CommitMapFacade],
})
export class CommitMap {
  protected readonly vm = inject(CommitMapFacade);
}
