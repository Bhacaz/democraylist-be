import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../democraylist/democraylist.service';
import {ActivatedRoute, Router} from '@angular/router';
import {LocalstorageService} from '../common/localstorage.service';
import templateString from './login.component.html'
import styleString from './login.component.scss'

@Component({
  selector: 'app-login',
  template: templateString,
  styles: [styleString]
})
export class LoginComponent implements OnInit {

  user;
  playlists: any = [];
  isLoading: boolean = true;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private democraylistService: DemocraylistService,
    private localstorageService: LocalstorageService
  ) { }

  ngOnInit(): void {
    if (!localStorage.getItem('access_token')) {
      this.route.queryParams.subscribe(params => {
        const code = params.code;
        if (code) {
          this.democraylistService.getSpotifyToken(code).subscribe(response => {
            this.user = response.user;
            this.localstorageService.setItem('access_token', response.access_token);
            this.localstorageService.setItem('user', JSON.stringify(response.user));
            const redirectUrl = sessionStorage.getItem('redirectUrl');
            if (redirectUrl) {
              sessionStorage.removeItem('redirectUrl');
              this.router.navigateByUrl(redirectUrl);
            } else {
              this.router.navigate(['/']);
            }
          });
        } else {
          this.isLoading = false;
        }
      });
    } else {
      this.authSpotify();
    }
  }

  authSpotify() {
    this.isLoading = true;
    localStorage.removeItem('access_token');
    this.democraylistService.getSpotifyAuthUrl().subscribe(response => {
      window.open(response.url, '_self');
    });
  }

}
