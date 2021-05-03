import {Component, Input, OnInit} from '@angular/core';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import {MenuItem} from 'primeng/api';
import templateString from './playlist-cover.component.html'
import stylesString from './playlist-cover.component.scss'
import {Router} from "@angular/router";

@Component({
  selector: 'app-playlist-cover',
  template: templateString,
  styles: [stylesString],
})
export class PlaylistCoverComponent implements OnInit {

  @Input() playlist;
  menuItems: MenuItem[];

  constructor(
    private democraylistService: DemocraylistService,
    private router: Router
  ) { }

  ngOnInit(): void {

  }

  showPlaylist() {
    this.router.navigate(['/playlists', this.playlist.id]);
  }
}
