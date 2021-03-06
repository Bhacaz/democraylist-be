import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import {ActivatedRoute} from '@angular/router';
import templateString from './playlist-stats.component.html'
import stylesString from './playlist-stats.component.scss'

@Component({
  selector: 'app-playlist-stats',
  template: templateString,
  styles: [stylesString],
})
export class PlaylistStatsComponent implements OnInit {

  stats: [];
  playlistId: number;

  constructor(
    private route: ActivatedRoute,
    private democraylistService: DemocraylistService
  ) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.playlistId = +params.id;
      this.democraylistService.getPlaylistStats(this.playlistId).subscribe(data => this.stats = data);
    });
  }
}
