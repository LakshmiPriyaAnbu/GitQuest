import { Component, computed, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { Commit } from '../../core/models';

const COLORS = ['#43E197', '#9B7CFF', '#FFC24B', '#FF6B9D', '#37D6E6', '#FF8A4C'];
const PAD_X = 52;
const PAD_Y = 46;
const COL_X = 92;
const ROW_Y = 80;

interface MapNode {
  id: string;
  x: number;
  y: number;
  color: string;
  isHead: boolean;
  isMerge: boolean;
  sha: string;
}

interface MapEdge {
  d: string;
  color: string;
}

@Component({
  selector: 'gq-commit-map',
  templateUrl: './commit-map.html',
  styleUrl: './commit-map.css',
})
export class CommitMap {
  private readonly router = inject(Router);
  protected readonly git = inject(GitApiService);
  protected readonly selectedId = signal<string | null>(null);

  constructor() {
    inject(GameStateService).completeQuest('q8', 'Read a commit graph', 20);
  }

  private readonly lanes = computed(() => {
    const s = this.git.state();
    const map = new Map<string, number>();
    if (!s) return map;
    for (const id of s.order) {
      const c = s.commits[id];
      if (!map.has(c.branch)) map.set(c.branch, map.size);
    }
    return map;
  });

  protected readonly legend = computed(() => {
    const lanes = this.lanes();
    return [...lanes.entries()].map(([name, lane]) => ({ name, color: COLORS[lane % COLORS.length] }));
  });

  private readonly headSha = computed(() => {
    const s = this.git.state();
    return s ? s.branches[s.head.ref] : null;
  });

  protected readonly nodes = computed<MapNode[]>(() => {
    const s = this.git.state();
    if (!s) return [];
    const lanes = this.lanes();
    return s.order.map((id, i) => {
      const c = s.commits[id];
      const lane = lanes.get(c.branch) ?? 0;
      return {
        id,
        x: PAD_X + i * COL_X,
        y: PAD_Y + lane * ROW_Y,
        color: COLORS[lane % COLORS.length],
        isHead: id === this.headSha(),
        isMerge: !!c.isMerge,
        sha: id,
      };
    });
  });

  protected readonly edges = computed<MapEdge[]>(() => {
    const s = this.git.state();
    if (!s) return [];
    const byId = new Map(this.nodes().map((n) => [n.id, n]));
    const out: MapEdge[] = [];
    for (const id of s.order) {
      const c = s.commits[id];
      const child = byId.get(id)!;
      for (const parentId of c.parents) {
        const parent = byId.get(parentId);
        if (!parent) continue;
        out.push({
          d: `M ${parent.x} ${parent.y} C ${parent.x + 46} ${parent.y}, ${child.x - 46} ${child.y}, ${child.x} ${child.y}`,
          color: child.color,
        });
      }
    }
    return out;
  });

  protected readonly mapW = computed(() => {
    const n = this.nodes().length;
    return Math.max(360, PAD_X * 2 + Math.max(0, n - 1) * COL_X + 30);
  });

  protected readonly mapH = computed(() => {
    const laneN = this.lanes().size || 1;
    return Math.max(150, PAD_Y * 2 + Math.max(0, laneN - 1) * ROW_Y + 30);
  });

  protected readonly selected = computed<Commit | null>(() => {
    const s = this.git.state();
    if (!s) return null;
    const id = this.selectedId() ?? this.headSha();
    return id ? (s.commits[id] ?? null) : null;
  });

  protected readonly selectedBranch = computed(() => this.selected()?.branch ?? '');

  protected readonly hasCommits = computed(() => (this.git.state()?.order.length ?? 0) > 0);

  select(id: string) {
    this.selectedId.set(id);
  }

  goPlayground() {
    this.router.navigateByUrl('/playground');
  }

  formatTime(t: number) {
    return new Date(t).toLocaleString();
  }
}
