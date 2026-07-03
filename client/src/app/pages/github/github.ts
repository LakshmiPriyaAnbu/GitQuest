import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Icon } from '../../shared/icon/icon';
import { GithubFacade } from './github.facade';

@Component({
  selector: 'gq-github',
  imports: [FormsModule, Icon],
  templateUrl: './github.html',
  styleUrl: './github.css',
  providers: [GithubFacade],
})
export class Github {
  protected readonly vm = inject(GithubFacade);
}
