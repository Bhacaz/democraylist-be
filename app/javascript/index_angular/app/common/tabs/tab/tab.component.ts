import {Component, Input} from '@angular/core';
import templateString from './tab.component.html'
import stylesString from './tab.component.scss'

@Component({
  selector: 'app-tab',
  template: templateString,
  styles: [stylesString],
})
export class TabComponent {

  @Input('tabTitle') title: string;
  @Input() active = false;
  renderContent = false;
}
