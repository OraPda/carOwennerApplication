import prompt from '@ohos.prompt';
import { DEFAULT } from '@ohos/hypium';
import {
  back,
  move,
  left,
  right,
  ledOn,
  ledOff,
  carGo,
  carBack,
  carLeft,
  carRight,
  carStop,
  changeCarState,
  getCarState,
  updateLight,
  stop
} from "../../http/ApiGroup"
import CarStateBean from "../../viewmodel/CarStateBean"
import LoadingDialog from "../../components/LoadingDialog"
import emitter from '@ohos.events.emitter';
import { StorageUtils } from '../../utils/StorageUtils';
import promptAction from '@ohos.promptAction';
import data from '@ohos.telephony.data';
import Queue from '@ohos.util.Queue';
import { CommonTitleBar } from '../../components/Header';
import FaultLogger from '@ohos.faultLogger';

/**
 * 车辆控制页面
 * @author Y
 * @data 2024.10.29
 */
@Preview
@Component
export default struct CarControllerTwo {
  // 灯光渲染控制
  @State lightOpen: boolean = false
  // 前进按钮渲染
  @State upPress: boolean = false
  // 后退按钮渲染
  @State downPress: boolean = false
  // 左转按钮渲染
  @State leftPress: boolean = false
  // 右转按钮渲染
  @State rightPress: boolean = false
  // 预定义
  @State carStateBean: CarStateBean = new CarStateBean();
  // 弹窗组件
  dialogController :CustomDialogController = new CustomDialogController({
    builder:LoadingDialog({
      textValue:"请稍后"
    }),
    alignment:DialogAlignment.Center,
    customStyle:true
  })
  /**
   * 控制车辆前进
   */
  async moveFont(){
    try {
      // 调用车辆前进
      await carGo();
      await move({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }

  /**
   * 控制车辆右转
   */
  async moveRight(){
    try {
      // 调用车辆右转
      await carRight();
      await right({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }

  /**
   * 控制车辆左转
   */
  async moveLeft(){
    try {
      // 调用车辆左转
      await carLeft();
      await left({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }

  /**
   * 控制车辆后退
   */
  async moveBack(){
    try {
      // 调用车辆后退
      await carBack();
      await back({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }

  /**
   * 控制车辆停止
   */
  async moveStop(){
    try {
      // 调用车辆停止
      await carStop();
      await stop({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }
  /**
   * 生命周期
   */
  async aboutToAppear(){
    let carState = await getCarState();
    this.carStateBean = carState["data"] as CarStateBean
    this.lightOpen = this.carStateBean.light == "1"
    emitter.on({
      eventId:1
    },(data) =>{
      let result = JSON.parse(data.data!["carState"]) as CarStateBean
      this.carStateBean = result
      this.carStateBean.light = result.light
      this.lightOpen = this.carStateBean.light == "1"
    })
  }

  /*
  修改车辆灯光状态信息
   */
  async changCarState(){
    let postData = new CarStateBean()
    let carId = await StorageUtils.get("carId","") as number
    try {
      /**
       * 根据不同的车架号调用接口修改不同车辆的灯光信息状态
       * @param: carId:车架号
       * @param: light:灯光属性值
       */
      postData.light = this.carStateBean.light
      await updateLight({carId:carId,light:postData.light})
       } catch (e) {
      promptAction.showToast({message:e})
    }
  }

  /**
   * 控制车辆行进
   * @param e:TouchEvent
   * @param: handle:number
   */
  async handleCarMove(e:TouchEvent,handle:number){
  //   判定用户是否按下
    if (e.type == TouchType.Down) {
    //   判定用户想要的前进方向
      switch (handle) {
        case 1:     //前进
          this.upPress = true
          this.moveFont();
          break;
        case 2:     //右转
          this.rightPress = true
          this.moveRight();
          break;
        case 3:     //左转
          this.leftPress = true
          this.moveLeft();
          break;
        case 4:     //后退
          this.downPress = true
          this.moveBack();
          break;
        default:
          break;
      }
    //   判定用户抬起手
    }else if (e.type  == TouchType.Up){
      this.upPress = false;
      this.rightPress =false;
      this.leftPress =false;
      this.downPress =false;
      this.moveStop();
    }
  }
  build() {
    Column(){
      Text("车辆控制")
        .width("100%")
        .padding(15)
        .fontColor("#fff")
        .fontSize(18)
        .textAlign(TextAlign.Center)
      Stack(){
        // 重叠图像实现图片双重绑定
        Image($r("app.media.bg_owner_normal"))
          .width("70%")
        Image($r("app.media.bg_owner_open_light"))
          .width("70%")
          .opacity(this.lightOpen ? 1:0) //判定渲染
        Row(){
          Stack(){
            Image($r("app.media.ic_light_open"))
              .width(80)
              .opacity(this.lightOpen ? 0:1)
            Image($r("app.media.ic_light_open_active"))
              .width(80)
              .opacity(this.lightOpen ? 1:0)
          }
        //   用户点击行为
          .onClick(() =>{
            this.dialogController.open()
          //   定时器2s
            setTimeout(async () =>{
              this.dialogController.close()
              try {
                this.lightOpen = !this.lightOpen
                this.carStateBean.light =  this.lightOpen ? "1":"0"
                this.changCarState()
                /**
                 * 调用接口实现车辆控制灯光
                 * @param this.carStateBean.light
                 */
                if (this.carStateBean.light == "1") {
                    await ledOn()
                }else {
                    await ledOff()
                }
              } catch (e) {
                  this.changCarState()
              }
            },2000)
          })
        }
        .width("100%")
        .margin({
          top:"10%"
        })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width("100%")
      .layoutWeight(1)
      Stack(){
        Stack(){
          Image($r("app.media.ic_direction"))
            .width(160)
          Image($r("app.media.ic_direction_up"))
            .width(160)
            .opacity(this.upPress ? 1:0)
          Image($r("app.media.ic_direction_right"))
            .width(160)
            .opacity(this.upPress ? 1:0)
          Image($r("app.media.ic_direction_left"))
            .width(160)
            .opacity(this.upPress ? 1:0)
          Image($r("app.media.ic_direction_down"))
            .width(160)
            .opacity(this.upPress ? 1:0)
        }

        Stack(){
          Column(){
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Red)
            // 用户触摸事件
              .onTouch((e) => this.handleCarMove(e,4))
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Gray)
          //   用户触摸事件
              .onTouch((e) => this.handleCarMove(e,1))
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height(160)
          .opacity(0)
          Row(){
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Green)
            // 用户触摸事件
              .onTouch((e) => this.handleCarMove(e,2))
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Blue)
            //   用户触摸事件
              .onTouch((e) => this.handleCarMove(e,3))
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width(160)
          .opacity(0)
        }
        .borderRadius(999)
        .width("90%")
      }
      .margin({
        bottom:20
        })
      }
    .width("100%")
    .height("100%")
    .backgroundImage($r("app.media.bg_car_control"))
    .backgroundImageSize({
      width:"100%",
      height:"100%"
    })
  }
}