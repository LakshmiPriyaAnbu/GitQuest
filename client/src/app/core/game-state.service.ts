import { Injectable, computed, effect, signal } from '@angular/core';
import { GameEvent, Toast, ToastKind } from './models';
import { LEVEL_TIERS, LEVEL_TITLES } from './game-data';

const STORAGE_KEY = 'gitquest_game_v1';
const MAX_VISIBLE_TOASTS = 4;

export interface Settings {
  theme: 'nebula' | 'candy';
  reduceMotion: boolean;
  animSpeed: number;
  cacheUser: boolean;
}

interface Persisted {
  xp: number;
  badges: Record<string, true>;
  quests: Record<string, true>;
  settings: Settings;
}

const DEFAULT_SETTINGS: Settings = { theme: 'nebula', reduceMotion: false, animSpeed: 1, cacheUser: true };

@Injectable({ providedIn: 'root' })
export class GameStateService {
  readonly xp = signal(0);
  readonly badges = signal<Record<string, true>>({});
  readonly quests = signal<Record<string, true>>({});
  readonly toasts = signal<Toast[]>([]);
  readonly settings = signal<Settings>({ ...DEFAULT_SETTINGS });

  private nextToastId = 1;

  readonly levelInfo = computed(() => {
    const xp = this.xp();
    let idx = 0;
    for (let i = 0; i < LEVEL_TIERS.length; i++) {
      if (xp >= LEVEL_TIERS[i]) idx = i;
    }
    const level = idx + 1;
    const title = LEVEL_TITLES[idx];
    const maxed = idx === LEVEL_TIERS.length - 1;
    const floor = LEVEL_TIERS[idx];
    const ceiling = LEVEL_TIERS[Math.min(idx + 1, LEVEL_TIERS.length - 1)];
    const pct = maxed ? 100 : Math.round(((xp - floor) / (ceiling - floor)) * 100);
    const toNext = maxed ? 0 : ceiling - xp;
    const nextLevel = maxed ? level : level + 1;
    return { level, title, pct, toNext, nextLevel, maxed };
  });

  readonly questsDone = computed(() => Object.keys(this.quests()).length);

  constructor() {
    this.hydrate();
    effect(() => {
      const snapshot: Persisted = {
        xp: this.xp(),
        badges: this.badges(),
        quests: this.quests(),
        settings: this.settings(),
      };
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(snapshot));
      } catch {
        /* localStorage unavailable — progress just won't persist */
      }
    });
  }

  private hydrate() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) return;
      const parsed: Partial<Persisted> = JSON.parse(raw);
      this.xp.set(parsed.xp ?? 0);
      this.badges.set(parsed.badges ?? {});
      this.quests.set(parsed.quests ?? {});
      this.settings.set({ ...DEFAULT_SETTINGS, ...parsed.settings });
    } catch {
      /* corrupt/missing storage — start fresh */
    }
  }

  award(amount: number, reason: string) {
    this.xp.update((v) => v + amount);
    this.toast(`+${amount} XP`, reason, 'xp');
  }

  unlock(id: string, title: string) {
    if (this.badges()[id]) return;
    this.badges.update((b) => ({ ...b, [id]: true }));
    this.toast('Badge unlocked!', title, 'badge');
  }

  completeQuest(id: string, title: string, xp?: number) {
    if (this.quests()[id]) return;
    this.quests.update((q) => ({ ...q, [id]: true }));
    if (xp) this.award(xp, `Quest: ${title}`);
  }

  applyEvents(events: GameEvent[]) {
    for (const e of events) {
      if (e.type === 'quest') this.completeQuest(e.id, e.title, e.xp);
      else if (e.type === 'badge') this.unlock(e.id, e.title);
      else if (e.type === 'xp') this.award(e.amount, e.reason);
    }
  }

  toast(title: string, body: string, kind: ToastKind) {
    const id = this.nextToastId++;
    const dur = Math.round(3200 / this.settings().animSpeed);
    this.toasts.update((list) => [...list, { id, title, body, kind, dur }].slice(-MAX_VISIBLE_TOASTS));
    setTimeout(() => this.dismissToast(id), dur);
  }

  dismissToast(id: number) {
    this.toasts.update((list) => list.filter((t) => t.id !== id));
  }

  updateSettings(patch: Partial<Settings>) {
    this.settings.update((s) => ({ ...s, ...patch }));
  }

  resetProgress() {
    this.xp.set(0);
    this.badges.set({});
    this.quests.set({});
  }
}
