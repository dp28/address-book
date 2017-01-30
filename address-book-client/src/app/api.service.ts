import { Injectable } from '@angular/core';
import { Http } from '@angular/http';
import { Observable } from 'rxjs';

const API_ROOT = 'http://localhost:3000/';

function urlTo(...pathParts: string[]): string {
  return `${API_ROOT}${pathParts.join('/')}`;
}

@Injectable()
export class ApiService {

  constructor(private http: Http) { }

  index<T>(entity: string): Observable<T[]> {
    return this.http.get(urlTo(entity)).map(response => response.json());
  }

}
