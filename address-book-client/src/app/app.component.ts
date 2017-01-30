import { Component } from '@angular/core';
import { Organisation } from './organisation/organisation.model';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  private selectedOrganisation: Organisation;

  private selectOrganisation(organisation: Organisation): void {
    this.selectedOrganisation = organisation;
  }
}
