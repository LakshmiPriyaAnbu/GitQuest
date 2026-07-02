import { Component } from '@angular/core';
import { InfoCard } from '../../shared/info-card/info-card';
import { INTERNALS_CARDS } from './internals-data';

@Component({
  selector: 'gq-internals',
  imports: [InfoCard],
  templateUrl: './internals.html',
  styleUrl: './internals.css',
})
export class Internals {
  protected readonly cards = INTERNALS_CARDS;
}
