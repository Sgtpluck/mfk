import { Injectable }     from '@angular/core';
import { Http, Response } from '@angular/http';
import { Observable }     from 'rxjs/Observable';

import { Person }         from './person'

import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/map';

@Injectable()
export class PersonService {
  private peopleUrl = 'http://localhost:8080/';  // URL to web API

  constructor (private http: Http) {}
  addPerson(person): Observable<Person[]> {
    return this.http.post(this.peopleUrl, {'name': person})
                   .map(this.extractPerson)
                   .catch(this.handleError);
  }
  private extractPerson(res: Response) {
    let body = res.json();
    return body.person || { };
  }

  getPeople(): Observable<Person[]> {
    return this.http.get(this.peopleUrl)
                   .map(this.extractData)
                   .catch(this.handleError);
  }
  private extractData(res: Response) {
    let body = res.json();
    return body.candidates || { };
  }

  vote(people): Observable<JSON[]> {
    return this.http.put(this.peopleUrl, people)
                   .map(this.extractStats)
                   .catch(this.handleError);
  }
  private extractStats(res: Response) {
    let body = res.json();
    return body.stats || { };
  }

  private handleError (error: Response | any) {
    let errMsg: string;
    if (error instanceof Response) {
      const body = error.json() || '';
      const err = body.error || JSON.stringify(body);
      errMsg = `${error.status} - ${error.statusText || ''} ${err}`;
    } else {
      errMsg = error.message ? error.message : error.toString();
    }
    console.error(errMsg);
    return Observable.throw(errMsg);
  }
}
