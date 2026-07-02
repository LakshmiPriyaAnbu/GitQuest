import { Component, computed, inject } from '@angular/core';
import { GitApiService } from '../../core/git-api.service';

@Component({
  selector: 'gq-branches',
  templateUrl: './branches.html',
  styleUrl: './branches.css',
})
export class Branches {
  protected readonly git = inject(GitApiService);

  protected readonly branches = computed(() => {
    const s = this.git.state();
    if (!s) return [];
    return Object.entries(s.branches).map(([name, sha]) => ({
      name,
      tip: sha ?? '(no commits)',
      isHead: name === s.head.ref,
    }));
  });

  protected readonly hasRepo = computed(() => !!this.git.state()?.initialized);
  protected readonly conflict = computed(() => this.git.state()?.conflict ?? null);

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
