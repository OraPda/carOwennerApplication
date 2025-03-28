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
 * @data 2024.0826
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
  //弹窗组件
  dialogController : CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      textValue:"请稍后"
    }),
    alignment:DialogAlignment.Center,
    customStyle:true
  })
  /**
   * 控制车辆行进
   */
  async moveFont(){
    try {
      //调用前进接口
      await carGo();
      await move({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }
  /**
   * 控制车辆后退
   */
  async moveBack(){
    try {
      //调用后退接口
      await carBack();
      await back({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }
  /**
   * 控制车辆左转
   */
  async moveLeft(){
    try {
      //调用左转接口
      await carLeft();
      await left({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }
  /**
   * 控制车辆行右转
   */
  async moveRight(){
    try {
      //调用右转接口
      await carRight();
      await right({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }
  /**
   * 控制车辆停止
   */
  async moveStop(){
    try {
      //调用停止接口
      await carStop();
      await stop({});
    } catch (e) {
      promptAction.showToast({message:e})
    }
  }

  /**
   * 生命周期
   */
  async aboutToAppear() {
    let carState = await getCarState();
    this.carStateBean = carState["data"] as CarStateBean
    this.lightOpen = (this.carStateBean.light == "1")
    emitter.on({
      eventId: 1
    }, (data) => {
      let result = JSON.parse(data.data!["carState"]) as CarStateBean
      this.carStateBean = result
      this.carStateBean.light = result.light
      this.lightOpen = (this.carStateBean.light == "1")
    })
  }


  /**
   * 修改车辆灯光状态信息
   */
  async changeCarState() {
    let postData = new CarStateBean()
    let carId = await StorageUtils.get("carId", "") as number
    try {
      postData.light = this.carStateBean.light
      /**修改车辆状态接口
       * @param carId
       * @param light
       */
      await updateLight({carId: carId,light: postData.light})
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }
  /**
   * 控制车辆行进功能
   * @param e:TouchEvent
   * @param handle:number
   */
  async handleCarMove(e:TouchEvent,handle:number){
    //   判定e用户按下
    if (e.type == TouchType.Down) {
      // 判定用户行进方向
      switch (handle) {
      // 前进
        case 1:
          this.upPress = true
          this.moveFont()
          break;
      // 右转
        case 2:
          this.rightPress = true
          this.moveRight()
          break;
      // 左转
        case 3:
          this.leftPress = true
          this.moveLeft()
          break;
      // 后退
        case 4:
          this.downPress = true
          this.moveBack()
          break;
        default:
          break;
      }
      // 判定用户抬起
    }else if(e.type == TouchType.Up){
      this.upPress = false;
      this.rightPress = false;
      this.leftPress = false;
      this.downPress = false;
      this.moveStop()
    }
  }


  build() {
    Column(){
      Text("车辆控制")
        .width("100%")
        .fontColor("#fff")
        .fontSize(18)
        .padding(15)
        .textAlign(TextAlign.Center)

      Stack(){
        Image($r("app.media.bg_owner_normal"))
          .width("70%")
        Image($r("app.media.bg_owner_open_light"))
          .width("70%")
            //设置开灯状态透明度
          .opacity(this.lightOpen ? 1:0)

        Row(){
          Stack(){
            // 按钮重叠图像与透明度
            Image($r("app.media.ic_light_open"))
              .width(80)
              .opacity(this.lightOpen?0:1)
            Image($r("app.media.ic_light_open_active"))
              .width(80)
              .opacity(this.lightOpen?1:0)
          }
          // 点击事件判定开关灯
          .onClick(() =>{
            this.dialogController.open();
            //异步定时器2s
            setTimeout(async () =>{
              this.dialogController.close();
              try {
                this.lightOpen = !this.lightOpen
                // console.log("this.lightOpen")
                this.carStateBean.light  = this.lightOpen ? "1":"0"
                this.changeCarState()
                /**
                 * 判断灯光属性值进行修改车辆灯光
                 * @param this.carStateBean.light
                 * 0 : 关灯
                 * 1：开灯
                 */
                if (this.carStateBean.light == "1") {
                  await ledOn()
                }else {
                  await ledOff()
                }
              } catch (e) {
                this.changeCarState()
              }
            },2000)
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width("90%")
        .margin({
          top:"10%"
        })
      }
      .layoutWeight(1)
      .width("100%")
      Stack(){
        Stack(){
          Image($r("app.media.ic_direction"))
            .width(160)
          Image($r("app.media.ic_direction_up"))
            .width(160)
            .opacity(this.upPress ? 1:0)
          Image($r("app.media.ic_direction_right"))
            .width(160)
            .opacity(this.rightPress ? 1:0)
          Image($r("app.media.ic_direction_left"))
            .width(160)
            .opacity(this.leftPress ? 1:0)
          Image($r("app.media.ic_direction_down"))
            .width(160)
            .opacity(this.downPress ? 1:0)
        }
        Stack() {
          Column() {
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Red)
                // 用户触摸事件
              .onTouch((e) => this.handleCarMove(e,1))

            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Gray)
                // 用户触摸事件
              .onTouch((e) => this.handleCarMove(e,4))

          }
          .height(160)
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Green)
                // 用户触摸事件
              .onTouch((e) => this.handleCarMove(e,3))
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Blue)
              .onTouch((e) => this.handleCarMove(e,2))
            // 用户触摸事件
          }
          .width(160)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width(160)
        .height(160)
        .borderRadius(999)
        .opacity(0)
      }
      .margin({
        bottom: 20
      })
    }
    .width("100%")
    .height("100%")
    .backgroundImage($r("app.media.bg_car_control"))
    .backgroundImageSize({
      width: "100%",
      height: "100%"
    })
  }
}