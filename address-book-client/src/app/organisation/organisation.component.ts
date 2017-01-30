import { Component, Input, Output, EventEmitter } from '@angular/core';
import { OrganisationApiService } from '../organisation-api.service';
import { Organisation } from './organisation.model';
import { Person } from '../person/person.model';

@Component({
  selector: 'organisation',
  templateUrl: './organisation.component.html',
  styleUrls: ['./organisation.component.css']
})
export class OrganisationComponent {
  @Input() private organisation: Organisation;
  @Output() created = new EventEmitter();
  @Output() destroyed = new EventEmitter();
  private people: Person[] | null = null;
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

  private destroy(event): void {
    event.preventDefault();
    this.organisationApi.destroy(this.organisation).subscribe(() => {
      this.destroyed.emit(this.organisation);
    });
  }

  private fetchPeople(): void {
    this.organisationApi.getPeople(this.organisation).subscribe(people => this.people = people);
  }

  private removePerson(person: Person): void {
    this.organisationApi.removePerson(this.organisation, person).subscribe(() => this.fetchPeople());
  }

  private get isEmpty(): boolean {
    return this.people && this.people.length === 0;
  }

  private showPerson(person, event): void {
    event.preventDefault();
    document.getElementById(`person_${person.id}`).scrollIntoView();
  }

}
