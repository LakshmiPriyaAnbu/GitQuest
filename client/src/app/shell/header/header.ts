import { Component, inject } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
import { filter, map, startWith } from 'rxjs';
import { toSignal } from '@angular/core/rxjs-interop';
import { GameStateService } from '../../core/game-state.service';
import { GitApiService } from '../../core/git-api.service';
import { ROUTE_META } from '../../core/nav-data';
import { ViewportService } from '../../core/viewport.service';

@Component({
  selector: 'gq-header',
  templateUrl: './header.html',
  styleUrl: './header.css',
})
export class Header {
  protected readonly game = inject(GameStateService);
  protected readonly git = inject(GitApiService);
  protected readonly viewport = inject(ViewportService);
  private readonly router = inject(Router);

  protected readonly meta = toSignal(
    this.router.events.pipe(
      filter((e): e is NavigationEnd => e instanceof NavigationEnd),
      map((e) => ROUTE_META[e.urlAfterRedirects] ?? { title: 'GitQuest', sub: '' }),
      startWith(ROUTE_META[this.router.url] ?? { title: 'GitQuest', sub: '' })
    ),
    { initialValue: { title: 'GitQuest', sub: '' } }
  );

  protected readonly headLabel = () => {
    const state = this.git.state();
    if (!state) return 'no repo';
    return state.head.ref;
  };
}
