import { Component, OnInit, Input } from '@angular/core';
import { Observable } from 'rxjs';
import { PeopleApiService } from '../people-api.service';
import { Person } from '../person/person.model';
import { Organisation } from '../organisation/organisation.model';

@Component({
  selector: 'people',
  templateUrl: './people.component.html',
  styleUrls: ['./people.component.css']
})
export class PeopleComponent implements OnInit {
  @Input() private selectedOrganisation: Organisation;
  private people$: Observable<Person[]>;
  private newPerson: Person | null = null;
  private added = false;

  constructor(private peopleApi: PeopleApiService) { }

  ngOnInit() {
    this.fetchPeople();
  }

  private addNewPerson(): void {
    this.newPerson = this.newPerson || <Person>{ name: "", contact_details: {} };
  }

  private personCreated(): void {
    this.newPerson = null;
    this.fetchPeople();
    this.added = true;
  }

  private fetchPeople(): void {
    this.people$ = this.peopleApi.index();
  }

}
