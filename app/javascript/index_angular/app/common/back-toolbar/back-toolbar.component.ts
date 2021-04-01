import {Component, Input, OnChanges, OnInit, SimpleChanges} from '@angular/core';
import templateString from  './back-toolbar.component.html'

@Component({
  selector: 'app-back-toolbar',
  template: templateString,
  // styles: ['./back-toolbar.component.scss']
})
export class BackToolbarComponent implements OnInit, OnChanges {

  @Input() redirectPath;

  constructor() { }

  ngOnInit(): void {
  }

  ngOnChanges(changes: SimpleChanges) {
    this.redirectPath = changes.redirectPath.currentValue;
  }

}
