import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../democraylist/democraylist.service';

@Component({
  selector: 'app-explore',
  template: './explore.component.html',
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
