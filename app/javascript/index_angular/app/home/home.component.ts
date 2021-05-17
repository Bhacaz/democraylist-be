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
  query: string;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private democraticService: DemocraylistService,
    private localstorageService: LocalstorageService,
  ) { }

  ngOnInit(): void {
      this.democraticService.getUser()
        .subscribe(response => {
          this.isLoading = false;
          this.localstorageService.setItem('user', JSON.stringify(response.user));
          this.askForNotificationPermission();
          this.fetchHome();
          const redirectUrl = sessionStorage.getItem('redirectUrl');
          if (redirectUrl) {
            sessionStorage.removeItem('redirectUrl');
            this.router.navigateByUrl(redirectUrl);
          }
        })
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
                    this.democraticService.addPushSubscriber(subscription.toJSON()).subscribe()
                  }
                })
              }
            });
        }).catch(error => console.log(error));
    }
  }

  fetchHome() {
    this.democraticService.getHome().subscribe(data => {
      this.playlists = data;
      this.isLoading = false
    })
  }

  searchPlaylists() {
    this.democraticService.getHome(this.query).subscribe(data => {
      this.playlists = data;
    })
  }
}
