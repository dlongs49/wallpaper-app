import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import type { Permissions } from '@ohos.abilityAccessCtrl'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
const PERMISSIONS: Array<Permissions> = ['ohos.permission.INTERNET', 'ohos.permission.SET_WALLPAPER']

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    // let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    // try {
    //   atManager.requestPermissionsFromUser(this.context, PERMISSIONS).then((data) => {
    //     AppStorage.SetOrCreate('filePath', this.context.filesDir)
    //     AppStorage.SetOrCreate('context', this.context)
    //     console.info('appstart'+'MainAbility onCreate')
    //
    //   }).catch((err) => {
    //     console.info('appstart'+`err: ${JSON.stringify(err)}`)
    //
    //   })
    // } catch (err) {
    //   console.info('appstart'+ `catch err->${JSON.stringify(err)}`);
    // }
  }

  onDestroy() {
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    let context = this.context;
    let pathDir = context.filesDir;
    console.error("文件路径："+pathDir)
    // Main window is created, set main page for this ability
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        // hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      // hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
