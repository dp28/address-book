import { Component, Input, Output, EventEmitter } from '@angular/core';
import { OrganisationApiService } from '../organisation-api.service';
import { Organisation } from './organisation.model';

@Component({
  selector: 'organisation',
  templateUrl: './organisation.component.html',
  styleUrls: ['./organisation.component.css']
})
export class OrganisationComponent {
  @Input() private organisation: Organisation;
  @Output() created = new EventEmitter();
  private updated = false;

  constructor(private organisationApi: OrganisationApiService) { }

  private get isPersisted(): boolean {
    return Boolean(this.organisation.id);
  }

  private saveChanges(event): void {
    event.preventDefault();
    this.organisationApi.update(this.organisation).subscribe(organisation => {
      this.organisation = organisation;
      this.updated = true;
    });
  }

  private create(event): void {
    event.preventDefault();
    this.organisationApi.create(this.organisation).subscribe(organisation => {
      this.organisation = organisation;
      this.created.emit(organisation);
    });
  }

}
