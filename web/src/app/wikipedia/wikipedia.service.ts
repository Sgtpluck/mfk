import { Injectable } from '@angular/core';
import { URLSearchParams, Http, Response } from '@angular/http';

@Injectable()
export class WikipediaService {

  constructor(private http: Http) {}

  validatePerson(term: string) {
    let search = new URLSearchParams()
    search.set('action', 'query');
    search.set('titles', term);
    search.set('prop', 'categories');
    search.set('format', 'json');
    search.set('origin', '*');
    return this.http.get('https://en.wikipedia.org/w/api.php?', { search })
                .map((res) => {
                  return this.checkIfPerson(res.json())
                });
  }
  private checkIfPerson(wiki_data) {
    let is_person = false;
    // this awful line is necessary because the wikipedia API uses the page ID
    // as a key, and also does not give you any way to get at that key. So, cool.
    let cats = Object.keys(wiki_data.query.pages).map(k => wiki_data.query.pages[k])[0].categories
    if (cats) {
      for (let cat of cats) {
        if (cat.title.match("birth")) { is_person = true; }
      }
    }
    return is_person;
  }
}
