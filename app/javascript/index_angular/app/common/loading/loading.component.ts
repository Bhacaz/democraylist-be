import { Component, OnInit } from '@angular/core';
import templateString from './loading.component.html'
@Component({
  selector: 'app-loading',
  template: templateString,
  // styles: ['./loading.component.scss']
})
export class LoadingComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

}
