import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { PlaylistSharedStartpointComponent } from './playlist-shared-startpoint.component';

describe('PlaylistSharedStartpointComponent', () => {
  let component: PlaylistSharedStartpointComponent;
  let fixture: ComponentFixture<PlaylistSharedStartpointComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PlaylistSharedStartpointComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PlaylistSharedStartpointComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
