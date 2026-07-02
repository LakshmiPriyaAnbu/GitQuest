import { HttpClient } from '@angular/common/http';
import { Injectable, computed, inject, signal } from '@angular/core';
import { Observable, tap } from 'rxjs';
import { GameStateService } from './game-state.service';
import { GitCommandResponse, GitState } from './models';

const BASE = '/api/git';

@Injectable({ providedIn: 'root' })
export class GitApiService {
  private http = inject(HttpClient);
  private game = inject(GameStateService);

  readonly state = signal<GitState | null>(null);
  readonly loaded = computed(() => this.state() !== null);

  refresh(): Observable<{ state: GitState }> {
    return this.http.get<{ state: GitState }>(`${BASE}/state`).pipe(tap((res) => this.state.set(res.state)));
  }

  private apply(obs: Observable<GitCommandResponse>): Observable<GitCommandResponse> {
    return obs.pipe(
      tap((res) => {
        this.state.set(res.state);
        this.game.applyEvents(res.events);
      })
    );
  }

  runCommand(command: string) {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/command`, { command }));
  }

  reset() {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/reset`, {})).pipe(
      tap(() => this.game.toast('Reset', 'Playground reset', 'info'))
    );
  }

  branchSim() {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/branch-sim`, {}));
  }

  commitSim() {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/commit-sim`, {}));
  }

  mergeSim() {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/merge-sim`, {}));
  }

  armConflict() {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/conflict/arm`, {}));
  }

  dismissConflict() {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/conflict/dismiss`, {}));
  }

  resolveConflict(choice: 'current' | 'incoming' | 'both') {
    return this.apply(this.http.post<GitCommandResponse>(`${BASE}/conflict/resolve`, { choice }));
  }
}
