import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiService } from './api.service';
import { Organisation } from './organisation/organisation.model';

const ORGANISATION_ROUTE = 'organisations';
const ORGANISATION_PARAM_NAME = 'organisation';

@Injectable()
export class OrganisationApiService {

  constructor(private api: ApiService) { }

  index(): Observable<Organisation[]> {
    return this.api.index(ORGANISATION_ROUTE);
  }

  create(organisation: Organisation): Observable<Organisation> {
    return this.api.create(ORGANISATION_ROUTE, ORGANISATION_PARAM_NAME, organisation);
  }

  update(organisation: Organisation): Observable<Organisation> {
    return this.api.update(
      [ORGANISATION_ROUTE, String(organisation.id)],
      ORGANISATION_PARAM_NAME,
      organisation
     );
  }

  destroy(organisation: Organisation): Observable<Organisation> {
    return this.api.destroy([ORGANISATION_ROUTE, String(organisation.id)]);
  }
}
