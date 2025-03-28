import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import type { Permissions } from '@ohos.abilityAccessCtrl'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import { NFCUtils } from '../utils/NFCUtils';
import wsUtil from '../utils/WsUtil';
import webSocket from '@ohos.net.webSocket';

const PERMISSIONS: Array<Permissions> = ['ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.CAMERA', 'ohos.permission.INTERNET', 'ohos.permission.NFC_TAG']

export default class EntryAbility extends UIAbility {
  async  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    //这里要获取权限
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(this.context, PERMISSIONS).then((data) => {

      }).catch((err) => {
        console.info('appstart'+`err: ${JSON.stringify(err)}`)

      })
    } catch (err) {
      console.info('appstart'+ `catch err->${JSON.stringify(err)}`);
    }
    NFCUtils.getNFCInfo(want)

  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/start/StartPage',async  (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  async onNewWant(want: Want) {
    NFCUtils.getNFCInfo(want)
  }
}
