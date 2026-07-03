import { computed, inject, Injectable, signal } from '@angular/core';
import { GithubService } from '../../core/github.service';
import { deriveGithubStats } from '../../core/github-derived';
import { APP_CONTENT, type GithubCopy, type GithubStatCopy } from '../../generated/app-content';

@Injectable()
export class GithubFacade {
  private readonly github = inject(GithubService);

  readonly copy: GithubCopy = APP_CONTENT.github;
  readonly githubState = this.github;
  readonly username = signal('');

  readonly derived = computed(() => {
    const data = this.github.data();
    return data ? deriveGithubStats(data) : null;
  });

  readonly gameStats = computed(() => {
    const derived = this.derived();
    const user = this.github.data()?.user;
    if (!derived || !user) return [];
    const values: Record<string, number> = {
      contributions: derived.totalContributions,
      streak: derived.currentStreak,
      repositories: user.public_repos,
      languages: derived.languages.length,
      pullRequests: this.github.data()?.events.filter((event) => event.type === 'PullRequestEvent').length ?? 0,
      stars: derived.totalStars,
    };
    return this.copy.stats.map((stat: GithubStatCopy) => ({
      ...stat,
      value: values[stat.id] ?? 0,
    }));
  });

  submit() {
    const username = this.username().trim();
    if (username) this.github.load(username);
  }

  demo() {
    this.github.loadDemo();
  }
}
