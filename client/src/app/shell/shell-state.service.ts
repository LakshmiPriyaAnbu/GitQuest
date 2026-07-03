import { computed, inject, Injectable } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
import { filter, map, startWith } from 'rxjs';
import { toSignal } from '@angular/core/rxjs-interop';
import { GameStateService } from '../core/game-state.service';
import { GitApiService } from '../core/git-api.service';
import { APP_CONTENT, MOBILE_NAV, NAV_GROUPS, ROUTE_META } from '../generated/app-content';

@Injectable({ providedIn: 'root' })
export class ShellStateService {
  private readonly router = inject(Router);
  private readonly game = inject(GameStateService);
  private readonly git = inject(GitApiService);

  readonly shell = APP_CONTENT.shell;
  readonly groups = NAV_GROUPS;
  readonly mobileNav = MOBILE_NAV;

  readonly meta = toSignal(
    this.router.events.pipe(
      filter((event): event is NavigationEnd => event instanceof NavigationEnd),
      map((event) => ROUTE_META[event.urlAfterRedirects] ?? { title: this.shell.fallbackTitle, sub: this.shell.fallbackSubtitle }),
      startWith(ROUTE_META[this.router.url] ?? { title: this.shell.fallbackTitle, sub: this.shell.fallbackSubtitle })
    ),
    { initialValue: { title: this.shell.fallbackTitle, sub: this.shell.fallbackSubtitle } }
  );

  readonly headLabel = computed(() => this.git.state()?.head.ref ?? this.shell.headEmpty);
  readonly levelLabel = computed(() => `${this.shell.levelPrefix} ${this.game.levelInfo().level} · ${this.game.levelInfo().title}`);
  readonly xpLabel = computed(() => `${this.game.xp()} ${this.shell.xpSuffix}`);
}
