import Prompt from '@system.prompt'
import { back,
  carBack,
  carGo,
  carLeft,
  carRight,
  carStop,
  changeCarState, getCarState,
  ledOff,
  ledOn,
  left, move, right, stop,
  updateDoor,
  updateLight } from "../../http/ApiGroup"
import CarStateBean from '../../viewmodel/CarStateBean';
import webSocket from '@ohos.net.webSocket';
import promptAction from '@ohos.promptAction';
import { WS_URL } from '../../http/RequestUtil';
import { StorageUtils } from '../../utils/StorageUtils';
import emitter from '@ohos.events.emitter';
import LoadingDialog from '../../components/LoadingDialog';
import { CommonTitleBar } from '../../components/Header';


@Preview
@Component
export default struct VehicleControlComp {
  @State lightOpen: boolean = false;    // 灯开关
  @State doorOpen: boolean = false;     //门开关
  @State upPress: boolean = false;     //前进？
  @State downPress: boolean = false;    //后退？
  @State leftPress: boolean = false;    //左
  @State rightPress: boolean = false;   //右
  @State carStateBean: CarStateBean = new CarStateBean();      //Bean装配类，应该属于io
  // 弹出提示框
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      /**
       * loadingDialog : 是否是自带还是自写的组件
       */
      textValue: "操作中..",
    }),
    alignment: DialogAlignment.Center,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  //
  async aboutToAppear() {
    let carState = await getCarState();
    this.carStateBean = carState["data"] as CarStateBean
    this.doorOpen = (this.carStateBean.door == "1")
    this.lightOpen = (this.carStateBean.light == "1")
    emitter.on({
      eventId: 1
    }, (data) => {
      let result = JSON.parse(data.data!["carState"]) as CarStateBean     //声明为carStateBean类
      this.carStateBean = result
      this.carStateBean.door = result.door
      this.carStateBean.light = result.light
      this.doorOpen = (this.carStateBean.door == "1")
      this.lightOpen = (this.carStateBean.light == "1")
    })
  }

  /**
   * 修改状态功能
   * @param type 类型为num
   */
  async changeState(type: number) {
    let postData = new CarStateBean()    // io封装对象实例化
    let carId = await StorageUtils.get("carId", "") as number    //as声明为number类  异步请求StorageUtils
    /**
     * @param carId
     */
    try {
      if (type == 0) {
        // 根据type传入的参数进行判断开关灯或门
        postData.door = this.carStateBean.door
        // 实例化出的对象进行赋值，将现在carBean内容传入，再调用接口，
        /**
         * @param carId PostData
         * 该接口自定义形参为id与door
         */
        await updateDoor({carId: carId,door: postData.door})
      } else {
        postData.light = this.carStateBean.light
        /**
         * 同上
         */
        await updateLight({carId: carId,light: postData.light})
      }
      // await changeCarState(postData)
    } catch (e) {
      promptAction.showToast({ message: e })
    }

  }

  // 小车控制前进等
  async moveFront() {
    try {
      // 异步两个请求，
      /**
       * 一为：给数据库传入行走数据？？？
       * 二为：控制小车？？？？
       */
      await carGo()
    await move({})
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  async moveBack() {
    try {
      await carBack()
      await back({})
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  async moveLeft() {
    try {
      await carLeft()
      await left({})
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  async moveRight() {
    try {
      await carRight()
      await right({})
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  async moveStop() {
    try {
      await carStop()
      await stop({})
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }
/**
 * @param e
 * @param handle  通过数字1234判断前进后退等
 */
  async handleMoveCar(e: TouchEvent, handle: number) {
    // TouchType应该为按键状态，down为按下，up为放开
    if (e.type == TouchType.Down) {
      switch (handle) {
        case 1:
          this.upPress = true
          this.moveFront()
          break;
        case 2:
          this.rightPress = true
          this.moveRight()
          break;
        case 3:
          this.downPress = true
          this.moveBack()
          break;
        case 4:
          this.leftPress = true
          this.moveLeft()
          break;

        default:
          break;
      }
    } else if (e.type == TouchType.Up) {
      setTimeout(() => {
        this.upPress = false
        this.downPress = false
        this.leftPress = false
        this.rightPress = false
        this.moveStop()
      }, 20)
    }
  }

  build() {
    Column() {
      // 页面抬头显示
      Text("车辆控制")
        // 字号字色
        .normalText(18,"#fff")
        // 外边距
        .padding(15)
        // 宽
        .width("100%")
        // 对齐方式
        .textAlign(TextAlign.Center)

      // 重叠图像，通过opacity透明度判断显示哪个
      Stack({ alignContent: Alignment.Center }) {
        // 裸车图像
        Image($r("app.media.bg_owner_normal"))
          .width("70%")
        // 全开图像
        Image($r("app.media.bg_owner_all_open"))
          .width("70%")
            // 属性.opacity????????
          .opacity((this.doorOpen && this.lightOpen) ? 1 : 0)
        // 开门
        Image($r("app.media.bg_owner_open_door"))
          .width("70%")
          .opacity((this.doorOpen && !this.lightOpen) ? 1 : 0)
        // 开灯
        Image($r("app.media.bg_owner_open_light"))
          .opacity((!this.doorOpen && this.lightOpen) ? 1 : 0)
          .width("70%")

        Row() {

          Stack() {
            // 锁车按钮
            Image($r("app.media.ic_door_lock"))
              .width(40)
              .opacity(this.doorOpen ? 0 : 1)
            // 开门按钮
            Image($r("app.media.ic_door_lock_active"))
              .width(40)
              .opacity(this.doorOpen ? 1 : 0)
          }
          .onClick(() => {
            // 点击后调用此事件，弹出提示框并设置过期时间2000ms
            this.dialogController.open()
            setTimeout(()=>{
              this.dialogController.close()
              // 为什么这里是非？
              this.doorOpen = !this.doorOpen
              this.carStateBean.door = this.doorOpen ? "1" : "0"
              // 传入0，参数为type
              // 执行的是开关门操作
              this.changeState(0);
            },2000)

          })

          // 与上述基本相同
          Stack() {
            // 关灯状态
            Image($r("app.media.ic_light_open"))
              .width(40)
              .opacity(this.lightOpen ? 0 : 1)
            // 开灯状态
            Image($r("app.media.ic_light_open_active"))
              .width(40)
              .opacity(this.lightOpen ? 1 : 0)
          }
          .onClick(() => {
            this.dialogController.open()
            setTimeout(async  ()=>{
              try {
                this.dialogController.close()
                // 都是非，需要研究！！！
                this.lightOpen = !this.lightOpen
                // 将Bean内Light赋值1或0，lightOpen为boolean
                this.carStateBean.light = this.lightOpen ? "1" : "0"
                this.changeState(1);
                if (this.carStateBean.light=="1") {
                  await ledOn()
                }else {
                  await ledOff()
                }
              } catch (e) {
                this.changeState(1);
              }

            },2000)
          })
        }
        // 这个属性？？？？？？？？
        .justifyContent(FlexAlign.SpaceBetween)
        .width("90%")
        .margin({
          top: "10%"
        })
      }
      .layoutWeight(1)
      .width("100%")

      Stack() {
        Stack() {
          // 方向按键
          Image($r("app.media.ic_direction"))
            .width(160)
          // 前进按钮变色
          Image($r("app.media.ic_direction_up"))
            .width(160)
            .opacity(this.upPress ? 1 : 0)
          // 后退按钮变色
          Image($r("app.media.ic_direction_down"))
            .width(160)
            .opacity(this.downPress ? 1 : 0)
          Image($r("app.media.ic_direction_left"))
            .width(160)
            .opacity(this.leftPress ? 1 : 0)
          Image($r("app.media.ic_direction_right"))
            .width(160)
            .opacity(this.rightPress ? 1 : 0)
        }

        Stack() {

          Column() {
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Red)
              .onTouch((e) => this.handleMoveCar(e, 1))

            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Gray)
              .onTouch((e) => this.handleMoveCar(e, 3))

          }
          .height(160)
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Green)
              .onTouch((e) => this.handleMoveCar(e, 4))
            Row()
              .width(80)
              .height(80)
              .backgroundColor(Color.Blue)
              .onTouch((e) => this.handleMoveCar(e, 2))

          }
          .width(160)
          // ？？？？
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
      width:"100%",
      height:"100%"
    })
  }
}

@Extend(Text)
function normalText(fontSize: number, fontColor: string, fontWeight: FontWeight = FontWeight.Normal) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
}