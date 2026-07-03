import { Component, inject } from '@angular/core';
import { Icon } from '../../shared/icon/icon';
import { CommandLabFacade } from './command-lab.facade';

@Component({
  selector: 'gq-command-lab',
  imports: [Icon],
  templateUrl: './command-lab.html',
  styleUrl: './command-lab.css',
  providers: [CommandLabFacade],
})
export class CommandLab {
  protected readonly vm = inject(CommandLabFacade);
}
