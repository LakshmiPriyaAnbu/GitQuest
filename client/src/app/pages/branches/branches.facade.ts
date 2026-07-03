import { computed, inject, Injectable } from '@angular/core';
import { GitApiService } from '../../core/git-api.service';
import { APP_CONTENT, type BranchesCopy } from '../../generated/app-content';

@Injectable()
export class BranchesFacade {
  private readonly git = inject(GitApiService);

  readonly copy: BranchesCopy = APP_CONTENT.branches;
  readonly branches = computed(() => {
    const state = this.git.state();
    if (!state) return [];
    return Object.entries(state.branches).map(([name, sha]) => ({
      name,
      tip: sha ?? '(no commits)',
      isHead: name === state.head.ref,
    }));
  });
  readonly hasRepo = computed(() => !!this.git.state()?.initialized);
  readonly conflict = computed(() => this.git.state()?.conflict ?? null);
  readonly headRef = computed(() => this.git.state()?.head.ref ?? APP_CONTENT.playground.headNone);

  newBranch() {
    this.git.branchSim().subscribe();
  }

  commitHere() {
    this.git.commitSim().subscribe();
  }

  mergeMain() {
    this.git.mergeSim().subscribe();
  }

  startConflict() {
    this.git.armConflict().subscribe();
  }

  cancelConflict() {
    this.git.dismissConflict().subscribe();
  }

  resolve(choice: 'current' | 'incoming' | 'both') {
    this.git.resolveConflict(choice).subscribe();
  }

  switchTo(name: string) {
    this.git.runCommand(`git checkout ${name}`).subscribe();
  }
}
