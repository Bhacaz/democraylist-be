import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import {ActivatedRoute} from '@angular/router';

@Component({
  selector: 'app-playlist-stats',
  template: './playlist-stats.component.html',
  // styles: ['./playlist-stats.component.scss']
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
