import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../democraylist/democraylist.service';
import templateString from './explore.component.html'
import stylesString from './explore.component.scss'

@Component({
  selector: 'app-explore',
  template: templateString,
  styles: [stylesString],
})
export class ExploreComponent implements OnInit {

  playlists: [];

  constructor(
    private democraylistService: DemocraylistService
  ) { }

  ngOnInit(): void {
    this.democraylistService.getExplore()
      .subscribe(data => {
      this.playlists = data;
    });
  }

}
