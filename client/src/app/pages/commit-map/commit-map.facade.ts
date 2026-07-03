import { computed, inject, Injectable, signal } from '@angular/core';
import { Router } from '@angular/router';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { Commit } from '../../core/models';
import { APP_CONTENT, QUESTS, type CommitMapCopy } from '../../generated/app-content';
import { LANE_COLORS } from '../../generated/app-theme';

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

@Injectable()
export class CommitMapFacade {
  private readonly router = inject(Router);
  private readonly git = inject(GitApiService);
  private readonly selectedId = signal<string | null>(null);

  readonly copy: CommitMapCopy = APP_CONTENT.commitMap;

  constructor() {
    const quest = QUESTS.find((item) => item.id === 'q8');
    if (quest) {
      inject(GameStateService).completeQuest(quest.id, quest.title, quest.xp);
    }
  }

  private readonly lanes = computed(() => {
    const state = this.git.state();
    const map = new Map<string, number>();
    if (!state) return map;
    for (const id of state.order) {
      const commit = state.commits[id];
      if (!map.has(commit.branch)) map.set(commit.branch, map.size);
    }
    return map;
  });

  readonly legend = computed(() => [...this.lanes().entries()].map(([name, lane]) => ({ name, color: LANE_COLORS[lane % LANE_COLORS.length] })));
  private readonly headSha = computed(() => {
    const state = this.git.state();
    return state ? state.branches[state.head.ref] : null;
  });

  readonly nodes = computed<MapNode[]>(() => {
    const state = this.git.state();
    if (!state) return [];
    const lanes = this.lanes();
    return state.order.map((id, index) => {
      const commit = state.commits[id];
      const lane = lanes.get(commit.branch) ?? 0;
      return {
        id,
        x: PAD_X + index * COL_X,
        y: PAD_Y + lane * ROW_Y,
        color: LANE_COLORS[lane % LANE_COLORS.length],
        isHead: id === this.headSha(),
        isMerge: !!commit.isMerge,
        sha: id,
      };
    });
  });

  readonly edges = computed<MapEdge[]>(() => {
    const state = this.git.state();
    if (!state) return [];
    const byId = new Map(this.nodes().map((node) => [node.id, node] as const));
    const edges: MapEdge[] = [];
    for (const id of state.order) {
      const commit = state.commits[id];
      const child = byId.get(id)!;
      for (const parentId of commit.parents) {
        const parent = byId.get(parentId);
        if (!parent) continue;
        edges.push({
          d: `M ${parent.x} ${parent.y} C ${parent.x + 46} ${parent.y}, ${child.x - 46} ${child.y}, ${child.x} ${child.y}`,
          color: child.color,
        });
      }
    }
    return edges;
  });

  readonly mapW = computed(() => Math.max(360, PAD_X * 2 + Math.max(0, this.nodes().length - 1) * COL_X + 30));
  readonly mapH = computed(() => Math.max(150, PAD_Y * 2 + Math.max(0, (this.lanes().size || 1) - 1) * ROW_Y + 30));
  readonly selected = computed<Commit | null>(() => {
    const state = this.git.state();
    if (!state) return null;
    const id = this.selectedId() ?? this.headSha();
    return id ? state.commits[id] ?? null : null;
  });
  readonly selectedBranch = computed(() => this.selected()?.branch ?? '');
  readonly hasCommits = computed(() => (this.git.state()?.order.length ?? 0) > 0);

  select(id: string) {
    this.selectedId.set(id);
  }

  openPlayground() {
    this.router.navigateByUrl('/playground');
  }

  formatTime(time: number) {
    return new Date(time).toLocaleString();
  }
}
