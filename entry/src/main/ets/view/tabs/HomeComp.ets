import router from '@ohos.router'
import { getCarInfo } from '../../http/ApiGroup'
import CarInfoBean from '../../viewmodel/CarInfoBean'
import Prompt from '@system.prompt'
import { BASE_URL } from '../../http/RequestUtil'
import AirConditionerComp from '../home/AirConditionerComp'
import LoadingDialog from '../../components/LoadingDialog'
import matrix4 from '@ohos.matrix4'

/**
 * 主页面
 * @author yang
 * @Date 2024.07.20
 */
@Preview
@Component
export default struct HomeComp {
  @State carInfo: CarInfoBean = new CarInfoBean()
  /**
   * 生命周期
   */
  async aboutToAppear(){
    try {
      let result = await getCarInfo()
      this.carInfo = result['data']
    } catch (e) {
      Prompt.showToast({ message: e })
    }
  }
  build(){
    Column(){

      //头
      Row() {
        // 车主信息绑定，车辆名称显示
        Text(this.carInfo.carName === "" ? "未绑定" : this.carInfo.carName)
          .normalText(16, "#FFFFFF", FontWeight.Bold)
        Image($r("app.media.ic_owner_message"))
          .width(20)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/home/MessagePage'
            })
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")
      .margin({
        bottom: 40
      })

      //续航里程
      Row({ space: 3 }) {
        Text((Number(this.carInfo.batteryPower)*5)+"")
          .normalText(58, "#FFFFFF")

        Column({ space: 5 }) {
          Text("可续航")
            .normalText(14, "#FFFFFF")
          Text("km")
            .normalText(14, "#FFFFFF")
        }
        .alignItems(HorizontalAlign.Start)
      }
      .height(58)
      .alignItems(VerticalAlign.Bottom)

      //剩余电量

      Row({ space: 5 }){
        Progress({
          total: 100,
          value: parseInt(this.carInfo.batteryPower)
        })
          .backgroundColor("#E9EBEB")
          .color("#0B72FE")
          .style({
            strokeWidth: 3
          })
          .layoutWeight(1)
          .margin({ top: 5 })

        Text(this.carInfo.batteryPower + "%")
          .normalText(12, "#FFFFFF")

      }
      .width("60%")
      .margin({ top: 12 })

      //更新时间
      Text("更新于 " + this.carInfo.updateTime)
        .normalText(12, "#29FFFFFF")
        .margin({ top: 14 })

      //车辆图片
      Image(BASE_URL + this.carInfo.carPic)
        .width("90%")
        .margin({ top: 60, bottom: 40 })

      //控制按钮组
      AirConditionerComp()

    }
    .width("100%")
    .alignItems(HorizontalAlign.Start)
    .backgroundImage($r("app.media.bg_home"))
    .backgroundImageSize({
      width: "100%",
      height: "100%"
    })
    .height("100%")
    .padding({
      top: 25,
      left: 25,
      right: 25
    })
  }
}

@Extend(Text)
function normalText(fontSize: number, fontColor: string, fontWeight: FontWeight = FontWeight.Normal) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
}