import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import {Router} from '@angular/router';
import templateString from './playlist-list.component.html';
import stylesString from './playlist-list.component.scss';

@Component({
  selector: 'app-playlist-list',
  template: templateString,
  styles: [stylesString],
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
