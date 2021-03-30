import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import {ActivatedRoute, Router} from '@angular/router';

@Component({
  selector: 'app-playlists-new',
  template: './playlists-new.component.html',
  // styles: ['./playlists-new.component.scss']
})
export class PlaylistsNewComponent implements OnInit {
  playlistId: number;
  playlist = {
    name: '',
    description: '',
    song_size: 50,
    share_setting: 'visible'
  };

  constructor(private democraylistService: DemocraylistService,
              private router: Router,
              private route: ActivatedRoute) {
    this.route.params.subscribe(params => {
      this.playlistId = +params.id;
      if (this.playlistId) {
        this.democraylistService.getPlaylist(this.playlistId).subscribe(data => {
          this.playlist = data;
        });
      }
    });
  }

  ngOnInit(): void {
  }

  onSubmit() {
    if (this.playlistId) {
      this.democraylistService.updatePlaylist(this.playlist).subscribe(data => {
        this.redirectToPlaylist();
      });
    } else {
      this.democraylistService.newPlaylist({
        name: this.playlist.name,
        description: this.playlist.description,
        song_size: this.playlist.song_size,
        share_setting: this.playlist.share_setting
      }).subscribe(data => {
        this.playlistId = data.id;
        this.redirectToPlaylist();
      });
    }
  }

  redirectToPlaylist() {
    this.router.navigate(['/playlists', this.playlistId]);

  }

  shareSettingHint(): string {
    return {
      visible: 'Everybody can see and collaborate to the playlist.',
      with_link: 'Only user with the playlist link can access and collaborate to the playlist.',
      restricted: 'Only user who received an invitation can collaborate to the playlist.'
    }[this.playlist.share_setting];
  }
}
