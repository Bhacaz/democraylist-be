import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { PlaylistListComponent } from './playlist-list.component';

describe('PlaylistListComponent', () => {
  let component: PlaylistListComponent;
  let fixture: ComponentFixture<PlaylistListComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PlaylistListComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PlaylistListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
