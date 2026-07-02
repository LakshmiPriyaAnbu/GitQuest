import { Component, ElementRef, computed, inject, signal, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { GitApiService } from '../../core/git-api.service';
import { Icon } from '../../shared/icon/icon';

interface Suggestion {
  cmd: string;
  hint: string;
}

const SUGGESTIONS: Suggestion[] = [
  { cmd: 'git init', hint: 'Start tracking this folder' },
  { cmd: 'git status', hint: 'See what has changed' },
  { cmd: 'git add .', hint: 'Stage everything' },
  { cmd: 'git commit -m "my first commit"', hint: 'Save a snapshot' },
  { cmd: 'git branch feature-ui', hint: 'Fork a new path' },
  { cmd: 'git checkout -b feature-ui', hint: 'Create and switch in one step' },
  { cmd: 'git merge feature-ui', hint: 'Bring a branch back together' },
  { cmd: 'git log', hint: 'See your commit history' },
];

@Component({
  selector: 'gq-playground',
  imports: [Icon, FormsModule],
  templateUrl: './playground.html',
  styleUrl: './playground.css',
})
export class Playground {
  protected readonly git = inject(GitApiService);
  protected readonly suggestions = SUGGESTIONS;
  protected readonly command = signal('');

  private readonly termEl = viewChild<ElementRef<HTMLDivElement>>('termBody');

  protected readonly state = computed(() => this.git.state());

  protected readonly workingCount = computed(() => `${this.state()?.workingDir.length ?? 0} files`);
  protected readonly stagingCount = computed(() => `${this.state()?.staging.length ?? 0} files`);
  protected readonly commitCount = computed(() => `${this.state()?.order.length ?? 0} commits`);

  protected readonly repoCommitsView = computed(() => {
    const s = this.state();
    if (!s) return [];
    const headSha = s.branches[s.head.ref];
    const grads = ['linear-gradient(140deg,#43E197,#2fbf7d)', 'linear-gradient(140deg,#9B7CFF,#7452e0)', 'linear-gradient(140deg,#37D6E6,#20a9b8)'];
    return s.order.slice(-6).map((sha, i) => ({
      sha,
      isHead: sha === headSha,
      grad: grads[i % grads.length],
    }));
  });

  protected readonly branchPills = computed(() => {
    const s = this.state();
    if (!s) return [];
    return Object.keys(s.branches).map((name) => ({
      name,
      isHead: name === s.head.ref,
    }));
  });

  runInput() {
    const cmd = this.command().trim();
    if (!cmd) return;
    this.run(cmd);
    this.command.set('');
  }

  runFromHistory(cmd: string) {
    this.run(cmd);
  }

  onKeydown(ev: KeyboardEvent) {
    if (ev.key === 'Enter') this.runInput();
  }

  reset() {
    this.git.reset().subscribe();
  }

  private run(cmd: string) {
    this.git.runCommand(cmd).subscribe(() => this.scrollToBottom());
  }

  private scrollToBottom() {
    setTimeout(() => {
      const el = this.termEl()?.nativeElement;
      if (el) el.scrollTop = el.scrollHeight;
    });
  }
}
