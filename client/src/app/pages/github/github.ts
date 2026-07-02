import { Component, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { GithubService } from '../../core/github.service';
import { deriveGithubStats } from '../../core/github-derived';
import { Icon } from '../../shared/icon/icon';

@Component({
  selector: 'gq-github',
  imports: [FormsModule, Icon],
  templateUrl: './github.html',
  styleUrl: './github.css',
})
export class Github {
  protected readonly github = inject(GithubService);
  protected readonly username = signal('');

  protected readonly derived = computed(() => {
    const data = this.github.data();
    return data ? deriveGithubStats(data) : null;
  });

  protected readonly gameStats = computed(() => {
    const d = this.derived();
    const user = this.github.data()?.user;
    if (!d || !user) return [];
    return [
      { label: 'Contributions', sub: 'XP', value: d.totalContributions },
      { label: 'Current streak', sub: 'Combo', value: d.currentStreak },
      { label: 'Repositories', sub: 'Worlds', value: user.public_repos },
      { label: 'Languages', sub: 'Power types', value: d.languages.length },
      { label: 'Pull requests', sub: 'Missions', value: this.github.data()?.events.filter((e) => e.type === 'PullRequestEvent').length ?? 0 },
      { label: 'Stars', sub: 'Reputation', value: d.totalStars },
    ];
  });

  submit() {
    const u = this.username().trim();
    if (u) this.github.load(u);
  }

  demo() {
    this.github.loadDemo();
  }
}
