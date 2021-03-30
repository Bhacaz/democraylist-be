import { Injectable } from '@angular/core';
import {Observable, Subject} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PlaylistChangeService {

  constructor() { }

  private subject$ = new Subject<any>();

  voteChanged(playlistId: number) {
    this.subject$.next(playlistId );
  }

  voteChanging(): Observable<any> {
    return this.subject$.asObservable();
  }
}
