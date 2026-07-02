import { Component, input } from '@angular/core';

@Component({
  selector: 'gq-icon',
  template: `
    <svg [attr.width]="size()" [attr.height]="size()" viewBox="0 0 24 24" fill="none">
      @switch (name()) {
        @case ('home') {
          <path d="M4 11l8-7 8 7v9a1 1 0 01-1 1h-4v-6H9v6H5a1 1 0 01-1-1v-9z" [attr.stroke]="stroke()" stroke-width="2" stroke-linejoin="round" />
        }
        @case ('play') {
          <path d="M6 4l14 8-14 8V4z" [attr.fill]="stroke()" />
        }
        @case ('lab') {
          <path d="M9 2v6.3L4 18a2 2 0 001.8 3h12.4a2 2 0 001.8-3l-5-9.7V2" [attr.stroke]="stroke()" stroke-width="2" stroke-linejoin="round" />
          <path d="M8 15h8" [attr.stroke]="stroke()" stroke-width="2" />
        }
        @case ('map') {
          <path d="M9 3L3 5v16l6-2 6 2 6-2V3l-6 2-6-2z" [attr.stroke]="stroke()" stroke-width="2" stroke-linejoin="round" />
          <path d="M9 3v16M15 5v16" [attr.stroke]="stroke()" stroke-width="2" />
        }
        @case ('branch') {
          <circle cx="6" cy="6" r="2.6" [attr.stroke]="stroke()" stroke-width="2.4" />
          <circle cx="6" cy="18" r="2.6" [attr.stroke]="stroke()" stroke-width="2.4" />
          <circle cx="18" cy="9" r="2.6" [attr.stroke]="stroke()" stroke-width="2.4" />
          <path d="M6 8.6v6.8M8.4 6.4c4 0 5.4 1.4 5.4 4.2" [attr.stroke]="stroke()" stroke-width="2.4" stroke-linecap="round" />
        }
        @case ('internals') {
          <path d="M12 2l8 5v10l-8 5-8-5V7z" [attr.stroke]="stroke()" stroke-width="2" />
        }
        @case ('github') {
          <path
            [attr.fill]="stroke()"
            d="M12 2C6.48 2 2 6.58 2 12.25c0 4.53 2.87 8.37 6.84 9.73.5.09.68-.22.68-.49l-.01-1.9c-2.78.62-3.37-1.2-3.37-1.2-.46-1.18-1.11-1.5-1.11-1.5-.9-.63.07-.62.07-.62 1 .07 1.53 1.05 1.53 1.05.89 1.56 2.34 1.11 2.91.85.09-.66.35-1.11.63-1.36-2.22-.26-4.55-1.14-4.55-5.07 0-1.12.39-2.03 1.03-2.75-.1-.26-.45-1.3.1-2.71 0 0 .84-.28 2.75 1.05a9.36 9.36 0 015 0c1.91-1.33 2.75-1.05 2.75-1.05.55 1.41.2 2.45.1 2.71.64.72 1.03 1.63 1.03 2.75 0 3.94-2.34 4.81-4.57 5.06.36.32.68.94.68 1.9l-.01 2.82c0 .27.18.59.69.49A10.02 10.02 0 0022 12.25C22 6.58 17.52 2 12 2z"
          />
        }
        @case ('xp') {
          <path [attr.fill]="stroke()" d="M12 2l2.9 6.3 6.9.7-5.1 4.6 1.4 6.8L12 17.6 5.9 20.4l1.4-6.8L2.2 9l6.9-.7z" />
        }
        @case ('quest') {
          <path d="M12 2a7 7 0 00-4 12.7V17a1 1 0 001 1h6a1 1 0 001-1v-2.3A7 7 0 0012 2z" [attr.stroke]="stroke()" stroke-width="2" />
          <path d="M9 21h6" [attr.stroke]="stroke()" stroke-width="2" stroke-linecap="round" />
        }
        @case ('learn') {
          <path d="M4 6a2 2 0 012-2h10l4 4v10a2 2 0 01-2 2H6a2 2 0 01-2-2V6z" [attr.stroke]="stroke()" stroke-width="2" stroke-linejoin="round" />
          <path d="M8 12h8M8 16h5" [attr.stroke]="stroke()" stroke-width="2" stroke-linecap="round" />
        }
        @case ('settings') {
          <circle cx="12" cy="12" r="3" [attr.stroke]="stroke()" stroke-width="2" />
          <path
            d="M19 12a7 7 0 00-.14-1.4l2-1.55-2-3.46-2.36.95a7 7 0 00-2.42-1.4L13.6 3h-3.2l-.48 2.14a7 7 0 00-2.42 1.4l-2.36-.95-2 3.46 2 1.55A7 7 0 004 12c0 .48.05.94.14 1.4l-2 1.55 2 3.46 2.36-.95a7 7 0 002.42 1.4L10.4 21h3.2l.48-2.14a7 7 0 002.42-1.4l2.36.95 2-3.46-2-1.55c.09-.46.14-.92.14-1.4z"
            [attr.stroke]="stroke()"
            stroke-width="1.6"
            stroke-linejoin="round"
          />
        }
        @case ('check') {
          <path d="M5 12l5 5L20 7" [attr.stroke]="stroke()" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round" />
        }
        @case ('chevron-down') {
          <path d="M6 9l6 6 6-6" [attr.stroke]="stroke()" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" />
        }
        @case ('trophy') {
          <path [attr.fill]="stroke()" d="M6 4h12v3a6 6 0 01-5 5.9V16h3v2H8v-2h3v-3.1A6 6 0 016 7V4z" />
        }
        @case ('flag') {
          <path [attr.stroke]="stroke()" stroke-width="2" d="M6 3v18M6 4h11l-3 4 3 4H6" stroke-linejoin="round" />
        }
        @case ('reset') {
          <path
            [attr.stroke]="stroke()"
            stroke-width="2"
            stroke-linecap="round"
            d="M4 4v5h5M20 20v-5h-5M4.5 15a8 8 0 0014.5 3.5M19.5 9A8 8 0 005 5.5"
          />
        }
        @default {
          <circle cx="12" cy="12" r="8" [attr.stroke]="stroke()" stroke-width="2" />
        }
      }
    </svg>
  `,
})
export class Icon {
  readonly name = input('circle');
  readonly size = input(18);
  readonly stroke = input('currentColor');
}
