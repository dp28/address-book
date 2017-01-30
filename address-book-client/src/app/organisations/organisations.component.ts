import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { OrganisationApiService } from '../organisation-api.service';
import { Organisation } from '../organisation/organisation.model';

@Component({
  selector: 'organisations',
  templateUrl: './organisations.component.html',
  styleUrls: ['./organisations.component.css']
})
export class OrganisationsComponent implements OnInit {
  private organisations$: Observable<Organisation[]>;
  private newOrganisation: Organisation | null = null;
  private added = false;

  constructor(private organisationApi: OrganisationApiService) { }

  ngOnInit() {
    this.fetchOrganisations();
  }

  private addNewOrganisation(): void {
    this.newOrganisation = this.newOrganisation || <Organisation>{ name: "", contact_details: {} };
  }

  private organisationCreated(): void {
    this.newOrganisation = null;
    this.fetchOrganisations();
    this.added = true;
  }

  private fetchOrganisations(): void {
    this.organisations$ = this.organisationApi.index();
  }

}
