import { Component } from '@angular/core';
import { WikipediaService } from './wikipedia.service';
import { FormControl } from '@angular/forms';
import { Observable }  from 'rxjs/Observable';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';
import 'rxjs/add/operator/switchMap';

@Component({
  selector: 'wikipedia-search',
  templateUrl: './wikipedia.component.html',
})
export class WikipediaSearchComponent {

  term = new FormControl();
  isPerson: boolean = false;
  errorMessage;

  constructor(private wikipediaService: WikipediaService) {}

  attempt_to_add() {
    this.wikipediaService.validatePerson(this.term.value)
                      .subscribe(
                        isPerson => this.isPerson = isPerson,
                        error =>  this.errorMessage = <any>error);
  }
}
