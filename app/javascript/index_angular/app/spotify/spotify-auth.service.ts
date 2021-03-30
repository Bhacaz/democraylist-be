import { Injectable } from '@angular/core';
import {HttpClient, HttpClientModule} from '@angular/common/http';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SpotifyAuthService {

  constructor(
    private http: HttpClient
  ) { }

  // app.get('/login', function(req, res) {
  //   var scopes = 'user-read-private user-read-email';
  //   res.redirect('https://accounts.spotify.com/authorize' +
  //     '?response_type=code' +
  //     '&client_id=' + my_client_id +
  //     (scopes ? '&scope=' + encodeURIComponent(scopes) : '') +
  //     '&redirect_uri=' + encodeURIComponent(redirect_uri));
  // });

  auth(): Observable<any> {
    return this.http.get(
      'https://accounts.spotify.com/authorize' +
      '?response_type=code' +
      '&client_id=' + 'cb8636ffad174a70a3358d9e5dec6c86' +
      '&scope=' + encodeURIComponent('user-read-email playlist-read-private playlist-read-collaborative user-library-read user-library-modify') +
      '&redirect_uri=' + encodeURIComponent('http://localhost:4200/auth/sporify/callback')
    );
  }
}
