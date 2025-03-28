import { CommonTitleBar } from '../../components/Header'
import router from '@ohos.router'
import font from '@ohos.font'
import promptAction from '@ohos.promptAction';
import { bindCar, getUserInfo } from '../../http/ApiGroup';
import Prompt from '@system.prompt';
import inputMethod from '@ohos.inputMethod';
import { StorageUtils } from '../../utils/StorageUtils';

@Entry
@Component
export default struct PersonalInfo {
  @State pageHigh: number = 0
  @State vin: string = ""
  @State isComplete: boolean = false

  showTip(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000,
      bottom: this.pageHigh / 2
    });
  }

  aboutToAppear() {
  }

  build() {
    Column() {
      CommonTitleBar({ attribute: {
        showLeft: true,
        bg_color:"#1A1B24",
        closeCallback: () => {
          router.back()
        },
        title_text: "绑定车辆",
        showRight: false
      } })
      Column() {
        if (this.isComplete) {
          Image($r('app.media.ic_complete'))
            .width("25%")
            .margin({
              top: 88
            })
          Text("绑定成功")
            .normalText(16, "#3D3D3D",FontWeight.Bold)
            .margin({
              top: 28
            })
          Text("恭喜你，完成了车辆绑定")
            .normalText(12, "#EBEBEB")
            .margin({
              top: 10
            })
          Button("完成")
          .height(40)
          .margin({
            top: 30
          })
          .width("100%")
          .backgroundColor("#0B72FE")
          .onClick(() => {
            router.back()
          })
        } else {
          Column({ space: 10 }) {
            Text() {
              Span("车辆识别代码")
                .fontColor("#3D3D3D")
                .fontSize(16)
              Span("（即车架号，也称VIN码）")
                .fontColor("#999999")
                .fontSize(12)
            }

            TextInput({ placeholder: '请输入您的车辆识别代号', text: this.vin })
              .borderRadius(0)
              .padding({
                top: 10,
                bottom: 10,
                left: 0,
                right: 0
              })
              .border({
                width: { bottom: 1 },
                color: "#2F2F2F"
              })
              .placeholderColor("#999999")
              .placeholderFont({
                size: 14
              })
              .style(TextInputStyle.Inline)
              .onChange((v) => {
                this.vin = v
              })
              .fontSize(14)
              .fontColor('#999999')
            Button("下一步")
            .height(40)
            .margin({
              top: 30
            })
            .width("100%")
            .backgroundColor("#0B72FE")
            .onClick(() => {
              if (this.vin.length < 1) {
                this.showTip("车架号错误，请检查车架号是否正确")
              } else {
                // 调用接口
                this.bindCarFunction()
              }
            })
          }
          .width("100%")
          .height("100%")
          .alignItems(HorizontalAlign.Start)
        }
      }
      .padding(15)
      .layoutWeight(1)
      .width("100%")
    }
    .backgroundImage($r("app.media.bg_car_control"))
    .backgroundImageSize({
      width:'100%',
      height:"100%"
    })
    .width("100%")
    .height("100%")
    .onAreaChange((o, n) => {
      this.pageHigh = n.height as number
    }
    )
  }

  async bindCarFunction() {
    inputMethod.getController().stopInputSession()
    try {
      let result = await bindCar({ carVin: this.vin })
      this.isComplete = true
      let userInfo = await getUserInfo()
      await StorageUtils.put("isLogin", true)
      await StorageUtils.put("carId",userInfo["carId"])
      await StorageUtils.put("carVin",userInfo["carVin"])
      // router.replaceUrl({
      //   url: "pages/login/LoginPage"
      // })
    } catch (e) {
      this.showTip(e)
      // Prompt.showToast({ message: e })
    }

  }
}

@Extend(Text)
function normalText(fontSize: number, fontColor: string, fontWeight: FontWeight = FontWeight.Normal) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
}
