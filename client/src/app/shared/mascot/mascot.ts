import { Component } from '@angular/core';

@Component({
  selector: 'gq-mascot',
  template: `
    <svg width="146" height="150" viewBox="0 0 146 150" style="animation: gq-float 4s ease-in-out infinite">
      <ellipse cx="73" cy="90" rx="52" ry="48" fill="#43E197" stroke="#100B2C" stroke-width="4" />
      <circle cx="73" cy="30" r="8" fill="#FFC24B" stroke="#100B2C" stroke-width="3" />
      <line x1="73" y1="38" x2="73" y2="52" stroke="#100B2C" stroke-width="3" />
      <ellipse cx="73" cy="98" rx="34" ry="30" fill="#FFF4E4" stroke="#100B2C" stroke-width="3" />
      <circle cx="60" cy="95" r="6" fill="#100B2C" />
      <circle cx="86" cy="95" r="6" fill="#100B2C" />
      <circle cx="52" cy="106" r="5" fill="#FF6B9D" opacity="0.6" />
      <circle cx="94" cy="106" r="5" fill="#FF6B9D" opacity="0.6" />
      <path d="M64 112q9 7 18 0" stroke="#100B2C" stroke-width="2.6" fill="none" stroke-linecap="round" />
      <path d="M28 100q-10 6-8 18" stroke="#100B2C" stroke-width="4" fill="none" stroke-linecap="round" />
      <path d="M118 100q10 6 8 18" stroke="#100B2C" stroke-width="4" fill="none" stroke-linecap="round" />
    </svg>
  `,
})
export class Mascot {}
