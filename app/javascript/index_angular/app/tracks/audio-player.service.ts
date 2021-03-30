import { Injectable } from '@angular/core';
import {BehaviorSubject, Observable, Subject} from 'rxjs';

@Injectable({
  providedIn: 'root'
})

export class AudioService {
  private player$ = new Subject();
  private audioObj = new Audio();
  public currentlyPlayingTrackId: string;

  constructor() {
    this.audioObj.addEventListener('ended', this.resetCurrentlyPlayingTrackId, false);
  }

  play(trackId: string, url: string) {
    if (this.currentlyPlayingTrackId === trackId) {
      this.audioObj.pause();
      this.player$.next(null);
    } else {
      this.currentlyPlayingTrackId = trackId;
      this.audioObj.src = url;
      this.audioObj.load();
      this.audioObj.play();
      this.player$.next(this.currentlyPlayingTrackId);
    }
  }

  private resetCurrentlyPlayingTrackId = (event) => {
    if (event.type === 'ended') {
      this.currentlyPlayingTrackId = null;
      this.player$.next(this.currentlyPlayingTrackId);
    }
  }

  audioPlayerEvent(): Observable<any> {
    return  this.player$.asObservable();
  }
}
