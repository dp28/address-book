import { Component, Input, Output, EventEmitter } from '@angular/core';
import { PeopleApiService } from '../people-api.service';
import { Person } from './person.model';

@Component({
  selector: 'person',
  templateUrl: './person.component.html',
  styleUrls: ['./person.component.css']
})
export class PersonComponent {
  @Input() private person: Person;
  @Output() created = new EventEmitter();
  private updated = false;

  constructor(private peopleApi: PeopleApiService) { }

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

}
