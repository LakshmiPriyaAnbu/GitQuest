import { Component, inject, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { GameStateService } from './core/game-state.service';
import { GitApiService } from './core/git-api.service';
import { ThemeService } from './core/theme.service';
import { ViewportService } from './core/viewport.service';
import { Sidebar } from './shell/sidebar/sidebar';
import { Header } from './shell/header/header';
import { MobileNav } from './shell/mobile-nav/mobile-nav';
import { ToastContainer } from './shared/toast-container/toast-container';

@Component({
  selector: 'gq-root',
  imports: [RouterOutlet, Sidebar, Header, MobileNav, ToastContainer],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App implements OnInit {
  protected readonly game = inject(GameStateService);
  protected readonly git = inject(GitApiService);
  protected readonly viewport = inject(ViewportService);
  private readonly theme = inject(ThemeService);

  ngOnInit() {
    void this.theme;
    this.git.refresh().subscribe();
  }
}
