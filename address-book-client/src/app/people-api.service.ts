import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiService } from './api.service';
import { Person } from './person/person.model';

const PERSON_ROUTE = 'people';

@Injectable()
export class PeopleApiService {

  constructor(private api: ApiService) { }

  index(): Observable<Person[]> {
    return this.api.index(PERSON_ROUTE);
  }
}
