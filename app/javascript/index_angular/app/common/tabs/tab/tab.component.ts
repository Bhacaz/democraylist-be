import {Component, Input} from '@angular/core';

@Component({
  selector: 'app-tab',
  template: './tab.component.html',
  // styles: ['./tab.component.scss']
})
export class TabComponent {

  @Input('tabTitle') title: string;
  @Input() active = false;
  renderContent = false;
}
