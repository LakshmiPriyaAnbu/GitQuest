import { Component, computed, inject } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { Icon } from '../../shared/icon/icon';
import { Mascot } from '../../shared/mascot/mascot';
import { FEATURES } from './dashboard-data';

@Component({
  selector: 'gq-dashboard',
  imports: [Icon, Mascot, RouterLink],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.css',
})
export class Dashboard {
  private readonly router = inject(Router);
  protected readonly game = inject(GameStateService);
  protected readonly git = inject(GitApiService);
  protected readonly features = FEATURES;

  protected readonly stats = computed(() => {
    const state = this.git.state();
    const commits = state ? state.order.length : 0;
    const branches = state ? Object.keys(state.branches).length : 0;
    return [
      { label: 'Commits made', value: String(commits), hint: 'crystals collected', bg: '#DFF7EA', color: '#0B3A26', hintColor: '#3d8a63' },
      { label: 'Branches', value: String(branches), hint: 'paths explored', bg: '#EAF6FF', color: '#123', hintColor: '#5a89a0' },
      { label: 'Quests done', value: `${this.game.questsDone()}/8`, hint: 'on the guided path', bg: '#FFF3D6', color: '#5B3D06', hintColor: '#a3862f' },
      { label: 'Badges', value: `${Object.keys(this.game.badges()).length}/8`, hint: 'earned so far', bg: '#EDE7FF', color: '#4B2CA0', hintColor: '#6b57a8' },
    ];
  });

  goPlayground() {
    this.router.navigateByUrl('/playground');
  }

  goGithub() {
    this.router.navigateByUrl('/github');
  }
}
