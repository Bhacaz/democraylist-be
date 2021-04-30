import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {DemocraylistService} from '../democraylist/democraylist.service';
import {LocalstorageService} from '../common/localstorage.service';
import templateString from './home.component.html'
import stylesString from './home.component.scss'

@Component({
  selector: 'app-home',
  template: templateString,
  styles: [stylesString]
})
export class HomeComponent implements OnInit {

  user;
  playlists: any = [];
  isLoading: boolean = true;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private democraticPlaylist: DemocraylistService,
    private localstorageService: LocalstorageService,
  ) { }

  ngOnInit(): void {
    if (localStorage.getItem('access_token')) {
      this.democraticPlaylist.getUser()
        .subscribe(data => {
          this.isLoading = false;
          this.user = data.user;
          this.askForNotificationPermission();
          }, error => this.redirectToLogin());
    } else {
      this.route.queryParams.subscribe(params => {
        const code = params.code;
        if (code) {
          this.democraticPlaylist.getSpotifyToken(code).subscribe(response => {
            this.isLoading = false;
            this.user = response.user;
            localStorage.setItem('access_token', response.access_token);
          });
        } else {
          this.isLoading = false;
          this.redirectToLogin();
        }
      });
    }
  }

  redirectToLogin() {
    this.localstorageService.removeItem('access_token');
    this.localstorageService.removeItem('user');
    this.router.navigate(['/login']);
  }

  askForNotificationPermission() {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/service-worker.js')
        .then(registration => {
          // dev BEWrjXKrN7b4hUiqIV-cLYJvUjTI_ntQXV3kz7ZIWgBnbzSl-jvG8hzamjK71cKsBaSrF0pwwdl6TOEH9Lguk4Q
          // prod BHz4P66gP1n1P0MRRC9BZVvffVfQuP3INlE6ZWvMH8tcX8AA_GFk7pVx59YJJSLRke1zNPfqly3_oB5wbTJrb6o
          registration.pushManager.subscribe({ userVisibleOnly: true, applicationServerKey: 'BHz4P66gP1n1P0MRRC9BZVvffVfQuP3INlE6ZWvMH8tcX8AA_GFk7pVx59YJJSLRke1zNPfqly3_oB5wbTJrb6o'})
            .then(subscription => {
              if (Notification.permission !== 'denied') {
                Notification.requestPermission().then(permission => {
                  console.log(permission);
                  if (permission === 'granted') {
                    this.democraticPlaylist.addPushSubscriber(subscription.toJSON()).subscribe()
                  }
                })
              }
            });
        }).catch(error => console.log(error));
    }
  }
}
