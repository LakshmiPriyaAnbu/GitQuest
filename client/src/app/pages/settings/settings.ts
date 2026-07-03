import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { SettingsFacade } from './settings.facade';
import { SettingsExportService } from './settings-export.service';

@Component({
  selector: 'gq-settings',
  imports: [FormsModule],
  templateUrl: './settings.html',
  styleUrl: './settings.css',
  providers: [SettingsFacade, SettingsExportService],
})
export class Settings {
  protected readonly vm = inject(SettingsFacade);
}
