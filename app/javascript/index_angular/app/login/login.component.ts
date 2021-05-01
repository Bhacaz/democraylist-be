import { Component, OnInit } from '@angular/core';
import {DemocraylistService} from '../democraylist/democraylist.service';
import {ActivatedRoute, Router} from '@angular/router';
import templateString from './login.component.html'
import stylesString from './login.component.scss'

@Component({
  selector: 'app-login',
  template: templateString,
  styles: [stylesString]
})
export class LoginComponent implements OnInit {

  user;
  playlists: any = [];
  isLoading: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private democraylistService: DemocraylistService,
  ) { }

  ngOnInit(): void {

  }

  authSpotify() {
    this.isLoading = true;
    localStorage.removeItem('access_token');
    this.democraylistService.getSpotifyAuthUrl().subscribe(response => {
      window.open(response.url, '_self');
    });
  }

}
