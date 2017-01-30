import { Component, Input, Output, EventEmitter } from '@angular/core';
import { PeopleApiService } from '../people-api.service';
import { OrganisationApiService } from '../organisation-api.service';
import { Person } from './person.model';
import { Organisation } from '../organisation/organisation.model';

@Component({
  selector: 'person',
  templateUrl: './person.component.html',
  styleUrls: ['./person.component.css']
})
export class PersonComponent {
  @Input() private person: Person;
  @Input() private selectedOrganisation: Organisation;
  @Output() created = new EventEmitter();
  @Output() destroyed = new EventEmitter();
  private updated = false;
  private added = false;

  constructor(
    private peopleApi: PeopleApiService,
    private organisationApi: OrganisationApiService
  ) { }

  private get isPersisted(): boolean {
    return Boolean(this.person.id);
  }

  private saveChanges(event): void {
    event.preventDefault();
    this.peopleApi.update(this.person).subscribe(person => {
      this.person = person;
      this.updated = true;
    });
  }

  private create(event): void {
    event.preventDefault();
    this.peopleApi.create(this.person).subscribe(person => {
      this.person = person;
      this.created.emit(person);
    });
  }

  private destroy(event): void {
    event.preventDefault();
    this.peopleApi.destroy(this.person).subscribe(() => {
      this.destroyed.emit(this.person);
    });
  }

  private addToSelectedOrganisation(): void {
    this
      .organisationApi
      .addPersonToOrganisation(this.person, this.selectedOrganisation)
      .subscribe(() => this.added = true);
  }

}
