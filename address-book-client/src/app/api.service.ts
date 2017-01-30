import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Observable } from 'rxjs';

const API_ROOT = 'http://localhost:3000/';

function urlTo(...pathParts: string[]): string {
  return `${API_ROOT}${pathParts.join('/')}`;
}

function asJson<T>(observableResponse: Observable<Response>): Observable<T> {
  return observableResponse.map(response => response.json());
}

@Injectable()
export class ApiService {

  constructor(private http: Http) { }

  index<T>(...pathParts: string[]): Observable<T[]> {
    return asJson(this.http.get(urlTo(...pathParts)));
  }

  create<T>(path: string, entityName: string, entity: T): Observable<T> {
    return asJson(this.http.post(urlTo(path), { [entityName]: entity }));
  }

  update<T>(pathParts: string[], entityName: string, entity: T): Observable<T> {
    return asJson(this.http.put(urlTo(...pathParts), { [entityName]: entity }));
  }

  destroy<T>(pathParts: string[]): Observable<T> {
    return asJson(this.http.delete(urlTo(...pathParts)))
  }

}
