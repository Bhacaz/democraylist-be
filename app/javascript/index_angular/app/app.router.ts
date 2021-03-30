import {Routes} from '@angular/router';
import {LoginComponent} from './login/login.component';
import {HomeComponent} from './home/home.component';
import {PlaylistsNewComponent} from './playlists/playlists-new/playlists-new.component';
import {PlaylistShowComponent} from './playlists/playlist-show/playlist-show.component';
import {PlaylistStatsComponent} from './playlists/playlist-stats/playlist-stats.component';
import {SharedComponent} from './tracks/shared/shared.component';
import {PlayslitAddTrackComponent} from './playlists/playslit-add-track/playslit-add-track.component';
import {PlaylistSharedStartpointComponent} from './playlists/playlist-shared-startpoint/playlist-shared-startpoint.component';

export const appRoutes: Routes = [
  { path: '',      component: HomeComponent },
  { path: 'login',      component: LoginComponent },
  { path: 'share',      component: SharedComponent },
  { path: 'auth/spotify/callback', component: LoginComponent },
  { path: 'p/:hash', component: PlaylistSharedStartpointComponent },
  {
    path: 'playlists',
    children: [
      { path: 'new', component: PlaylistsNewComponent },
      {
        path: ':id',
        children: [
          { path: '', component: PlaylistShowComponent} ,
          { path: 'edit', component: PlaylistsNewComponent },
          { path: 'add-track', component: PlayslitAddTrackComponent },
          { path: 'stats', component: PlaylistStatsComponent },
        ]
      }
    ]
  },
  {
    path: '**',
    redirectTo: '/',
    pathMatch: 'full'
  }
];
