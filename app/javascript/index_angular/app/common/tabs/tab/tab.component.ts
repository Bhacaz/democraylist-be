import {Component, Input} from '@angular/core';
import templateString from './tab.component.html'

@Component({
  selector: 'app-tab',
  template: templateString,
  // styles: ['./tab.component.scss']
})
export class TabComponent {

  @Input('tabTitle') title: string;
  @Input() active = false;
  renderContent = false;
}
