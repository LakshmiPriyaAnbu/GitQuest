import { Injectable } from '@angular/core';
import { TOAST_STYLES } from '../../generated/app-theme';
import { ToastKind } from '../../core/models';

@Injectable({ providedIn: 'root' })
export class ToastPresenterService {
  readonly styles = TOAST_STYLES;

  style(kind: ToastKind) {
    return this.styles[kind];
  }
}
