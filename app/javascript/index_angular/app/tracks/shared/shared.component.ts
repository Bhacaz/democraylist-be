import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {DemocraylistService} from '../../democraylist/democraylist.service';

@Component({
  selector: 'app-shared',
  template: './shared.component.html',
  // styles: ['./shared.component.scss']
})
export class SharedComponent implements OnInit {

// {"text":"Voici une chanson pour toi… Memories de Maroon 5\nhttps://open.spotify.com/track/2b8fOow8UzyDFAE27YhOZM?si=peaqXRHBQuCGIdBCitYwxA"}

  track;
  playlists;
  loading = true;
  constructor(
    private route: ActivatedRoute,
    private democraylistService: DemocraylistService,
    private router: Router
  ) {
      this.route.queryParams.subscribe(params => {
        const regex = /track\/([a-zA-Z0-9]+)/;
        if (params.text.match(regex)) {
          const trackId = params.text.match(regex)[1];

          this.democraylistService.searchByTrackId(trackId).subscribe(data => {
            this.track = data;
            this.track.playlist_id = -1;
            this.democraylistService.getAccessiblePlaylists(trackId).subscribe(data => {
              this.playlists = data;
              this.loading = false;
            });
          }, error => {
            this.loading = false;
          });
        } else {
          this.loading = false;
        }
      });
  }

    ngOnInit(): void {
  }

  navigateBack() {
    this.router.navigate(['/']);
  }

}
