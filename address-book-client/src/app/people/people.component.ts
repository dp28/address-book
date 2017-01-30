import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { PeopleApiService } from '../people-api.service';
import { Person } from '../person/person.model';

@Component({
  selector: 'people',
  templateUrl: './people.component.html',
  styleUrls: ['./people.component.css']
})
export class PeopleComponent implements OnInit {
  private people$: Observable<Person[]>;

  constructor(private peopleApi: PeopleApiService) { }

  ngOnInit() {
    this.people$ = this.peopleApi.index();
  }

}
