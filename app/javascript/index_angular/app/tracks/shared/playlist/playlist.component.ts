import {Component, Input, OnInit} from '@angular/core';
import {DemocraylistService} from '../../../democraylist/democraylist.service';
import {Router} from '@angular/router';
import templateString from './playlist.component.html'

@Component({
  selector: 'app-playlist',
  template: templateString,
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
