import { Component, inject } from '@angular/core';
import { QuestsFacade } from './quests.facade';

@Component({
  selector: 'gq-quests',
  templateUrl: './quests.html',
  styleUrl: './quests.css',
  providers: [QuestsFacade],
})
export class Quests {
  protected readonly vm = inject(QuestsFacade);
}
