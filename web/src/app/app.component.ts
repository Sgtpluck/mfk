import { Component } from '@angular/core';

import { Person } from './person'
import { PersonService } from './person.service';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [PersonService]
})
export class AppComponent {
  errorMessage: string;
  people: Person[];
  mode = 'Observable';

  constructor (private personService: PersonService) {}

  ngOnInit(): void { this.getPeople(); }

  getPeople(): void {
    this.personService.getPeople()
                     .subscribe(
                       people => this.people = people,
                       error =>  this.errorMessage = <any>error);
  }


  available_selected_disabled(person: Person, action: string): string {
    if (person[action] === true) { return 'selected'; }
    if (person.selected === true) { return 'disabled'; }
    for (let people_person of this.people) {
      if (people_person[action] === true) { return 'disabled'; }
    }
    return "";
  };

  action_selected(action: string): boolean {
    for (let people_person of this.people) {
      if (people_person[action] === true) { return true; }
    }
    return false
  }

  onSelect(person: Person, action: string): void {
    if (person.selected === true && person[action] === true) {
      person.selected = false;
      person[action] = false;
    } else if (person.selected === true || this.action_selected(action)){
      return;
    } else {
      person.selected = true;
      person[action] = true;
    }
  };

  vote(): void {
    let finished: boolean = true;
    for (let person of this.people) {
      if (person.selected === false ) { finished = false; }
    }
    if (finished) {
      // post the results
    } else {
      // give an error message
    }
  }

}
