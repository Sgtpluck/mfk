import { Component } from '@angular/core';

import { Person } from './person/person'
import { PersonService } from './person/person.service';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [PersonService]
})
export class AppComponent {
  errorMessage: string;
  people: Person[];
  stats: JSON[];
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
    if (person.selected !== "unselected") { return 'disabled'; }
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
    if (person.selected === action) {
      person.selected = "unselected";
      person[action] = false;
    } else if (person.selected !== "unselected" || this.action_selected(action)){
      return;
    } else {
      person.selected = action;
      person[action] = true;
    }
  };

  vote(): void {
    let finished: boolean = true;
    let processedPeople = [];
    for (let person of this.people) {
      processedPeople.push({'name': person.name, 'vote': person.selected});
      if (person.selected === "unselected" ) { finished = false; }
    }
    if (finished) {
      this.personService.vote(processedPeople)
                       .subscribe(
                         stats => {this.stats = stats; this.getPeople()},
                         error =>  this.errorMessage = <any>error);
    } else {
      console.log("BAD");
      // give an error message
    }
  }

}
