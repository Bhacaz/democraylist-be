import {Component, Input, OnInit} from '@angular/core';
import {DemocraylistService} from '../../../democraylist/democraylist.service';
import {Router} from '@angular/router';

@Component({
  selector: 'app-playlist',
  template: './playlist.component.html',
  // styles: ['./playlist.component.scss']
})
export class PlaylistComponent implements OnInit {

  @Input() playlist;
  @Input() trackId;

  constructor(
    private democraylistService: DemocraylistService,
    private router: Router
  ) { }

  ngOnInit(): void {
  }

  selectPlaylist() {
    this.democraylistService.addTrackToPlaylist(this.playlist.id, this.trackId).subscribe(data => {
      this.router.navigate(['/playlists', this.playlist.id]);
    });
  }
}
