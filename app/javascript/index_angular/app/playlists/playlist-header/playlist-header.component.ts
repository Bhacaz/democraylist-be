import {Component, Input, OnInit} from '@angular/core';
import {MenuItem} from 'primeng/api';
import {Router} from '@angular/router';
import {DemocraylistService} from '../../democraylist/democraylist.service';
import templateString from './playlist-header.component.html'

@Component({
  selector: 'app-playlist-header',
  template: templateString,
  // styles: ['./playlist-header.component.scss']
})
export class PlaylistHeaderComponent implements OnInit {

  @Input() playlist;

  constructor(
    private router: Router,
    private democraylistService: DemocraylistService
  ) { }

  ngOnInit(): void {

  }

}
