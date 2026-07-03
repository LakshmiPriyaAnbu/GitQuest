import { Component, inject } from '@angular/core';
import { BranchesFacade } from './branches.facade';

@Component({
  selector: 'gq-branches',
  templateUrl: './branches.html',
  styleUrl: './branches.css',
  providers: [BranchesFacade],
})
export class Branches {
  protected readonly vm = inject(BranchesFacade);
}
