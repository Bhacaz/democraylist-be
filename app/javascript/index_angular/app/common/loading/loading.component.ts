import { Component, OnInit } from '@angular/core';
import templateString from './loading.component.html'
import styleString from './loading.component.scss'
@Component({
  selector: 'app-loading',
  template: templateString,
  styles: [styleString]
})
export class LoadingComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

}
