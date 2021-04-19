import {Component, Input, OnInit} from '@angular/core';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import {ActivatedRoute, Router} from '@angular/router';
import templateString from './playslit-add-track.component.html'
import stylesString from './playslit-add-track.component.scss'

@Component({
  selector: 'app-playslit-add-track',
  template: templateString,
  styles: [stylesString],
})
export class PlayslitAddTrackComponent implements OnInit {

  playlist;
  playlistId;
  recentlyPlayedTracks = [];
  recommendations = [];
  showTrackFinder;

  constructor(private democraylistService: DemocraylistService,
              private route: ActivatedRoute,
              private router: Router) {
    this.route.params.subscribe(params => {
      this.playlistId = +params.id;
      if (this.playlistId) {
        this.democraylistService.getPlaylist(this.playlistId).subscribe(data => {
          this.playlist = data;
        });
      }
    });
    this.getRecentlyPlayed();
    this.getRecommendations();
  }

  ngOnInit(): void {
    this.showTrackFinder = this.playlist.user_id === JSON.parse(localStorage.getItem('user')).id ||
    this.playlist.subscribed;
  }

  getRecentlyPlayed() {
    this.democraylistService.getRecentlyPlayedTracks().subscribe(data => {
      this.recentlyPlayedTracks = data;
    });
  }

  getRecommendations() {
    this.democraylistService.getPlaylisRecommendations(this.playlistId).subscribe(data => {
      this.recommendations = data;
    });
  }

  addTrack(trackId: string) {
    this.democraylistService.addTrackToPlaylist(this.playlistId, trackId)
      .subscribe(data => {
        this.playlist = data;
        this.router.navigate(['playlists', this.playlistId]);
      });
  }
}
