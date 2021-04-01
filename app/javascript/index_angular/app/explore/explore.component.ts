import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../democraylist/democraylist.service';
import templateString from './explore.component.html'

@Component({
  selector: 'app-explore',
  template: templateString,
  // styles: ['./explore.component.scss']
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
