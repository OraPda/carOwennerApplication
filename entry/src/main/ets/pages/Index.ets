import HomeComp from "../view/tabs/HomeComp"
import VehicleControlComp from "../view/tabs/VehicleControlComp"
import MineComp from "../view/tabs/MineComp"
import { WS_URL } from '../http/RequestUtil';
import promptAction from '@ohos.promptAction';
import { StorageUtils } from '../utils/StorageUtils';
import CarStateBean from '../viewmodel/CarStateBean';
import emitter from '@ohos.events.emitter';
import wsUtil from '../utils/WsUtil';
import webSocket from '@ohos.net.webSocket';
import Prompt from '@system.prompt';
import common from '@ohos.app.ability.common';
import DataStatisticsComp from '../view/tabs/DataStatisticsComp';
import CarControlTest from '../view/tabs/carControlTest';
import CarControllerTwo from "../view/tabs/CarControlerTestTwo"

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  private carId: string = "";


  async onPageShow() {
    wsUtil.initWs(webSocket.createWebSocket());
    try {
      this.carId = await StorageUtils.get("carId", "") as string;
      await wsUtil.connectWs()
      wsUtil.onOpen();
      wsUtil.onMsg((value) => {
        console.log("carstate",value)
        let result = JSON.parse(value);
        if (result.text == undefined && result["carId"] == this.carId) {
          emitter.emit({
            eventId: 1
          }, {
            data: {
              carState: value,
            }
          })
        }
      })
    } catch (e) {
      console.log("zzq",JSON.stringify(e))
    }
  }

  async onPageHide() {
    await wsUtil.onWsDestroy()
  }

  build() {
    Column() {
      Tabs({
        index: this.currentIndex,
        barPosition: BarPosition.End,
      }) {
        //首页
        TabContent() {
          HomeComp()
        }
        .tabBar(this.tabBuilder(0, '首页', $r("app.media.ic_owner_home_active"), $r("app.media.ic_owner_home")))

        //车辆控制
        TabContent() {
          // CarControllerTwo()
          CarControlTest()
          // VehicleControlComp()
        }
        .tabBar(this.tabBuilder(1, '车辆控制', $r("app.media.ic_owner_control_active"), $r("app.media.ic_owner_control")))

        // 数据统计
        TabContent() {
          DataStatisticsComp()
        }
        .tabBar(this.tabBuilder(2, '数据统计', $r("app.media.ic_owner_statistics_active"), $r("app.media.ic_owner_statistics")))

        //我的
        TabContent() {
          MineComp()
        }
        .tabBar(this.tabBuilder(3, '我的', $r("app.media.ic_owner_mine_active"), $r("app.media.ic_owner_mine")))

      }
      .barHeight(55)
      .scrollable(false)
      .animationDuration(150)
      .barMode(BarMode.Fixed)
      .onChange((index) => {
        this.currentIndex = index
        // this.changePage(index)
      })
    }
    .backgroundColor("#181A1E")
    .height('100%')
  }

  @Builder
  tabBuilder(index: number, title: string, selectedImage: Resource, normalImage: Resource) {
    Column() {
      Image(this.currentIndex == index ? selectedImage : normalImage)
        .size({ width: 20, height: 20 })
      Text(title)
        .fontSize(12)
        .fontColor(this.currentIndex == index ? '#0B72FE' : '#B8B8B8')
        .lineHeight(22)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}