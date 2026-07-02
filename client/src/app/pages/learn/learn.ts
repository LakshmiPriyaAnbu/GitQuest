import { Component } from '@angular/core';
import { InfoCard } from '../../shared/info-card/info-card';
import { LEARN_CARDS } from './learn-data';

@Component({
  selector: 'gq-learn',
  imports: [InfoCard],
  templateUrl: './learn.html',
  styleUrl: './learn.css',
})
export class Learn {
  protected readonly cards = LEARN_CARDS;
}
