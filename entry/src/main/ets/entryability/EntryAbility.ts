import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) { }
  onDestroy() {}
  onWindowStageCreate(windowStage: window.WindowStage) {
    let context = this.context;
    let pathDir = context.filesDir;
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        return;
      }
    });
    windowStage.getMainWindow((err, winclass) => {
      if(err.code){
        return
      }
      let av = winclass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let rect = av.topRect
    })
  }

  onWindowStageDestroy() {}

  onForeground() {}

  onBackground() {
  }
}
