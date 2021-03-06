import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../democraylist/democraylist.service';
import templateString from './subscriptions.component.html'
import stylesString from './subscriptions.component.scss'

@Component({
  selector: 'app-subscriptions',
  template: templateString,
  styles: [stylesString],
})
export class SubscriptionsComponent implements OnInit {

  playlists: [];

  constructor(
    private democraylistService: DemocraylistService
  ) { }

  ngOnInit(): void {
    this.democraylistService.getSubscriptions()
      .subscribe(data => {
        this.playlists = data;
      });
  }

}
