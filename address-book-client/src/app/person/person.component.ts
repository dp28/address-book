import { Component, Input } from '@angular/core';
import { Person } from './person.model';

@Component({
  selector: 'person',
  templateUrl: './person.component.html',
  styleUrls: ['./person.component.css']
})
export class PersonComponent {
  @Input() private person: Person;

  constructor() { }

}
