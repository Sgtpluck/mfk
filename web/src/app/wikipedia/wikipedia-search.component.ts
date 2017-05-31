import { Component }        from '@angular/core';
import { WikipediaService } from './wikipedia.service';
import { FormControl }      from '@angular/forms';
import { Observable }       from 'rxjs/Observable';
import { PersonService }    from '../person/person.service';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';
import 'rxjs/add/operator/switchMap';

@Component({
  selector: 'wikipedia-search',
  templateUrl: './wikipedia.component.html',
})
export class WikipediaSearchComponent {

  term = new FormControl();
  errorMessage;

  constructor(private wikipediaService: WikipediaService,
              private personService: PersonService) {}

  attempt_to_add = () => {
    this.wikipediaService.validatePerson(this.titleize(this.term.value))
                          .subscribe(
                            isPerson => {
                              if (isPerson) {
                                this.addPerson();
                                this.term = new FormControl();
                              } else {
                                alert("Sorry, I couldn't confirm that that's a person!")
                              }
                            },
                            error =>  this.errorMessage = <any>error);
  };
  private titleize = (name) => {
    let nameArray = name.split(' ').map(function(str) {
      return str.charAt(0).toUpperCase() + str.slice(1);
    });
    return nameArray.join(' ');
  }

  addPerson = () => {
      this.personService.addPerson(this.titleize(this.term.value))
                       .subscribe(
                         people => alert(this.term.value + " has been added"),
                         error =>  this.errorMessage = <any>error);
  }
}
