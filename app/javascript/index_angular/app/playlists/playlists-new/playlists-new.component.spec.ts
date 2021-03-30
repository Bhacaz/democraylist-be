import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { PlaylistsNewComponent } from './playlists-new.component';

describe('PlaylistsNewComponent', () => {
  let component: PlaylistsNewComponent;
  let fixture: ComponentFixture<PlaylistsNewComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PlaylistsNewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PlaylistsNewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
