import {ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnInit} from '@angular/core';
import {SlideUpToggleAnimation} from './utility/bottom-sheet.animation';
import {MenuItem} from 'primeng/api';
import templateString from './bottom-sheet.component.html';
import stylesString from './bottom-sheet.component.scss';

@Component({
  selector: 'app-bottom-sheet',
  template: templateString,
  styles: [stylesString],
  animations: [SlideUpToggleAnimation],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class BottomSheetComponent implements OnInit {

  flags: any = {
    isBottomSheetEnabled: false
  };
  @Input() title: string;
  @Input() menuItems: MenuItem[];

  constructor(private changeDetector: ChangeDetectorRef) {
  }

  ngOnInit() {

  }

  open() {
    this.flags.isBottomSheetEnabled = true;
    this.changeDetector.detectChanges();
  }

  close() {
    this.flags.isBottomSheetEnabled = false;
    this.changeDetector.detectChanges();
  }

  toggle() {
    this.flags.isBottomSheetEnabled = !this.flags.isBottomSheetEnabled;
    this.changeDetector.detectChanges();
  }
}
