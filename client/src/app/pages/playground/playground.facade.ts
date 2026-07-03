import { Injectable, computed, inject, signal } from '@angular/core';
import { GitApiService } from '../../core/git-api.service';
import { APP_CONTENT } from '../../generated/app-content';
import { COMMIT_GRADIENTS } from '../../generated/app-theme';

@Injectable()
export class PlaygroundFacade {
  private readonly git = inject(GitApiService);
  private terminalElement?: HTMLDivElement;

  readonly copy = APP_CONTENT.playground;
  readonly command = signal('');
  readonly state = computed(() => this.git.state());
  readonly suggestions = this.copy.suggestions;

  readonly workingCount = computed(() => `${this.state()?.workingDir.length ?? 0} ${this.copy.countLabels.filesSuffix}`);
  readonly stagingCount = computed(() => `${this.state()?.staging.length ?? 0} ${this.copy.countLabels.filesSuffix}`);
  readonly commitCount = computed(() => `${this.state()?.order.length ?? 0} ${this.copy.countLabels.commitsSuffix}`);

  readonly repoCommitsView = computed(() => {
    const state = this.state();
    if (!state) return [];
    const headSha = state.branches[state.head.ref];
    return state.order.slice(-6).map((sha, index) => ({
      sha,
      isHead: sha === headSha,
      grad: COMMIT_GRADIENTS[index % COMMIT_GRADIENTS.length],
    }));
  });

  readonly branchPills = computed(() => {
    const state = this.state();
    if (!state) return [];
    return Object.keys(state.branches).map((name) => ({
      name,
      isHead: name === state.head.ref,
    }));
  });

  attachTerminal(element: HTMLDivElement | undefined) {
    this.terminalElement = element;
  }

  runInput() {
    const command = this.command().trim();
    if (!command) return;
    this.run(command);
    this.command.set('');
  }

  runFromHistory(command: string) {
    this.run(command);
  }

  onKeydown(event: KeyboardEvent) {
    if (event.key === 'Enter') this.runInput();
  }

  reset() {
    this.git.reset().subscribe();
  }

  private run(command: string) {
    this.git.runCommand(command).subscribe(() => this.scrollToBottom());
  }

  private scrollToBottom() {
    setTimeout(() => {
      if (this.terminalElement) {
        this.terminalElement.scrollTop = this.terminalElement.scrollHeight;
      }
    });
  }
}
