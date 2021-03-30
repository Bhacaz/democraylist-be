import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import {Router} from '@angular/router';

@Component({
  selector: 'app-playlist-list',
  template: './playlist-list.component.html',
  // styles: ['./playlist-list.component.scss']
})
export class PlaylistListComponent implements OnInit {

  playlists: Array<any> = [];

  constructor(
    private democraylistService: DemocraylistService,
    private router: Router
  ) { }

  ngOnInit(): void {
    this.getPlaylists();
  }

  getPlaylists() {
    this.democraylistService.getPlaylists()
      .subscribe(data => this.playlists = data);
  }

}
