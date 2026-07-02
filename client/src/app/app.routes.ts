import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
  { path: 'dashboard', loadComponent: () => import('./pages/dashboard/dashboard').then((m) => m.Dashboard) },
  { path: 'playground', loadComponent: () => import('./pages/playground/playground').then((m) => m.Playground) },
  { path: 'commandlab', loadComponent: () => import('./pages/command-lab/command-lab').then((m) => m.CommandLab) },
  { path: 'commitmap', loadComponent: () => import('./pages/commit-map/commit-map').then((m) => m.CommitMap) },
  { path: 'branches', loadComponent: () => import('./pages/branches/branches').then((m) => m.Branches) },
  { path: 'internals', loadComponent: () => import('./pages/internals/internals').then((m) => m.Internals) },
  { path: 'learn', loadComponent: () => import('./pages/learn/learn').then((m) => m.Learn) },
  { path: 'github', loadComponent: () => import('./pages/github/github').then((m) => m.Github) },
  { path: 'xp', loadComponent: () => import('./pages/xp/xp').then((m) => m.Xp) },
  { path: 'quests', loadComponent: () => import('./pages/quests/quests').then((m) => m.Quests) },
  { path: 'settings', loadComponent: () => import('./pages/settings/settings').then((m) => m.Settings) },
  { path: '**', redirectTo: 'dashboard' },
];
