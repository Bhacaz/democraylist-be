import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {DemocraylistService} from '../../democraylist/democraylist.service';

@Component({
  selector: 'app-playlist-shared-startpoint',
  template: './playlist-shared-startpoint.component.html',
  // styles: ['./playlist-shared-startpoint.component.scss']
})
export class PlaylistSharedStartpointComponent implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private democraylistService: DemocraylistService
  ) {
    this.route.params.subscribe(params => {
      const playlistHash = params.hash;
      this.democraylistService.getPlaylistIdFromHash(playlistHash).subscribe(data => {
        this.router.navigate(['playlists', data.id]);
      });
    });
  }

  ngOnInit(): void {
  }

}
