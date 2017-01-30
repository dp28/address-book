import { Component, Input } from '@angular/core';
import { PeopleApiService } from '../people-api.service';
import { Person } from './person.model';

@Component({
  selector: 'person',
  templateUrl: './person.component.html',
  styleUrls: ['./person.component.css']
})
export class PersonComponent {
  @Input() private person: Person;
  private updated = false;

  constructor(private peopleApi: PeopleApiService) { }

  private saveChanges(event): void {
    event.preventDefault();
    this.peopleApi.update(this.person).subscribe(person => {
      this.person = person;
      this.updated = true;
    });
  }

}
