import { Injectable } from '@angular/core';
import {HttpClient, HttpParams} from '@angular/common/http';
import {interval, Observable} from 'rxjs';
import {environment} from '../../environment';

@Injectable({
  providedIn: 'root'
})
export class DemocraylistService {

  backendUrl = environment.backendUrl;

  constructor(
    private http: HttpClient
  ) {
    // Every 25 minutes
    interval(1000 * 60 * 25).subscribe(x => {
      this.getRefreshAcessToken().subscribe(res => {
        localStorage.setItem('access_token', res.access_token);
      });
    });
  }

  // USER

  getSpotifyAuthUrl(): Observable<any> {
    return this.http.get(this.backendUrl + 'auth/spotify_login_url');
  }

  getSpotifyToken(code: string): Observable<any> {
    return this.http.post(this.backendUrl + 'auth/spotify_get_token', { code });
  }

  getRefreshAcessToken(): Observable<any> {
    return this.http.get(this.backendUrl + 'auth/refresh_access_token');
  }

  getUser(): Observable<any> {
    return this.http.get(this.backendUrl + 'auth/user');
  }

  addPushSubscriber(sub: any): Observable<any> {
    return this.http.post(this.backendUrl + 'users/push_notif_preference', {preference: sub});
  }

  logoutUser(): Observable<any> {
    return this.http.post(this.backendUrl + 'auth/logout', {});
  }

  // PLAYLIST

  getPlaylists(): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists');
  }

  newPlaylist(playlist: any): Observable<any> {
    return this.http.post(this.backendUrl + 'playlists/create', { playlist });
  }

  updatePlaylist(playlist: any): Observable<any> {
    return this.http.put(this.backendUrl + 'playlists/' + playlist.id, { playlist });
  }

  getPlaylist(id: number): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists/' + id);
  }

  getExplore(): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists/explore');
  }

  getSubscriptions(): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists/subscriptions');
  }

  getAccessiblePlaylists(trackId): Observable<any> {
    const params = new HttpParams().set('track_id', trackId);
    return this.http.get(this.backendUrl + 'playlists/accessible', {params});
  }

  subscripbedToPlaylist(playlistId: number): Observable<any> {
    return this.http.post(this.backendUrl + 'playlists/' + playlistId + '/subscribed', {});
  }

  unsubscripbedToPlaylist(playlistId: number): Observable<any> {
    return this.http.post(this.backendUrl + 'playlists/' + playlistId + '/unsubscribed', {});
  }

  getPlaylistStats(id: number): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists/' + id + '/stats');
  }

  getPlaylisRecommendations(id: number): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists/' + id + '/recommendations');
  }

  getPlaylistShareLink(id: number): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists/' + id + '/shareable_link');
  }

  getPlaylistIdFromHash(hash: string): Observable<any> {
    return this.http.get(this.backendUrl + 'playlists/id_from_hash/' + hash);
  }

  // TACKS

  searchTracks(query: string): Observable<any> {
    const params = new HttpParams().set('q', query);
    return this.http.get(this.backendUrl + 'tracks/search', {params});
  }

  searchByTrackId(trackId: string): Observable<any> {
    const params = new HttpParams().set('track_id', trackId);
    return this.http.get(this.backendUrl + 'tracks/search', {params});
  }

  addTrackToPlaylist(playlistId: number, trackId: string) {
    return this.http.post(this.backendUrl + 'playlists/' + playlistId + '/add_track', { track_id: trackId });
  }

  removeTrackToPlaylist(trackId: string) {
    return this.http.delete(this.backendUrl + 'tracks/' + trackId);
  }

  upVotePatch(trackId: number): Observable<any> {
    return this.http.patch(this.backendUrl + 'tracks/' + trackId + '/up_vote', {});
  }

  downVotePatch(trackId: number): Observable<any> {
    return this.http.patch(this.backendUrl + 'tracks/' + trackId + '/down_vote', {});
  }

  // PLAYER

  playQueue(playlistId: number, queue: string): Observable<any> {
    return this.http.post(this.backendUrl + 'playlists/' + playlistId + '/play', {queue});
  }

  getUserPlayerDevices(): Observable<any> {
    return this.http.get(this.backendUrl + 'users/player/devices');
  }

  getRecentlyPlayedTracks(): Observable<any> {
    return this.http.get(this.backendUrl + 'users/player/recently_played_tracks');
  }
}
