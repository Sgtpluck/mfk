import { Component } from '@angular/core';

export class Person {
  id: number;
  selected: boolean;
  name: string;
  marry: boolean;
  fuck: boolean;
  kill: boolean;
}

var PEOPLE: Person[] = [
  {
    id: 1,
    name: 'Bobby Flay',
    selected: true,
    marry: false,
    fuck: true,
    kill: false
  },
  {
    id: 2,
    name: 'Mario Batali',
    selected: true,
    marry: true,
    fuck: false,
    kill: false
  },
  {
    id: 1,
    name: 'Guy Fieri',
    selected: false,
    marry: false,
    fuck: false,
    kill: false
  }
];

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'MFK';
  people = PEOPLE;

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

}
