import { Injectable, computed, signal } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class ViewportService {
  readonly width = signal(typeof window !== 'undefined' ? window.innerWidth : 1200);
  readonly isMobile = computed(() => this.width() < 900);
  readonly isDesktop = computed(() => !this.isMobile());

  constructor() {
    if (typeof window !== 'undefined') {
      window.addEventListener('resize', () => this.width.set(window.innerWidth));
    }
  }
}
