import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import type { Permissions } from '@ohos.abilityAccessCtrl'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
const PERMISSIONS: Array<Permissions> = ['ohos.permission.INTERNET', 'ohos.permission.SET_WALLPAPER']
export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
  }

  onDestroy() {
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    let context = this.context;
    let pathDir = context.filesDir;
    windowStage.loadContent('pages/Sign', (err, data) => {
      if (err.code) {
        return;
      }
    });
  }

  onWindowStageDestroy() {}

  onForeground() {}

  onBackground() {
  }
}
