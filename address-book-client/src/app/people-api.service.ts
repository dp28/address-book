import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiService } from './api.service';
import { Person } from './person/person.model';

const PERSON_ROUTE = 'people';
const PERSON_PARAM_NAME = 'person';

@Injectable()
export class PeopleApiService {

  constructor(private api: ApiService) { }

  index(): Observable<Person[]> {
    return this.api.index(PERSON_ROUTE);
  }

  create(person: Person): Observable<Person> {
    return this.api.create(PERSON_ROUTE, PERSON_PARAM_NAME, person);
  }

  update(person: Person): Observable<Person> {
    return this.api.update([PERSON_ROUTE, String(person.id)], PERSON_PARAM_NAME, person);
  }

  destroy(person: Person): Observable<Person> {
    return this.api.destroy([PERSON_ROUTE, String(person.id)]);
  }
}
