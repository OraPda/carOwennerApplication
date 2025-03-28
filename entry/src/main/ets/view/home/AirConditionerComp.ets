import { changeCarState, getCarState } from '../../http/ApiGroup';
import CarStateBean from '../../viewmodel/CarStateBean';
import promptAction from '@ohos.promptAction';
import emitter from '@ohos.events.emitter';
import LoadingDialog from '../../components/LoadingDialog';

@Component
export default struct AirConditionerComp {
  @State temIndex: number = 0
  @State temperature: string = "--";
  private temperatureList: string[] = ["20", "21", "22", "23", "24", "25", "26", "27", "28", "29"]
  @State autoOpen: boolean = false;
  @State acOpen: boolean = false;
  @State loopOpen: boolean = false;
  @State defoggingOpen: boolean = false;
  @State carStateBean: CarStateBean = new CarStateBean();
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      textValue: "操作中..",
    }),
    alignment: DialogAlignment.Center,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  async aboutToAppear() {
    let carState = await getCarState();
    this.carStateBean = carState["data"] as CarStateBean
    this.temIndex = parseInt(this.carStateBean.setTemp)
    this.temperature = this.temperatureList[this.temIndex]
    this.autoOpen = (this.carStateBean.auto == "1")
    this.acOpen = (this.carStateBean.acBtn == "1")
    this.loopOpen = (this.carStateBean.circulate == "1")
    this.defoggingOpen = (this.carStateBean.clearFog == "1")
    emitter.on({
      eventId: 1
    }, (data) => {
      let result = JSON.parse(data.data!["carState"]) as CarStateBean
      this.carStateBean = result
      this.autoOpen = (this.carStateBean.auto == "1")
      this.acOpen = (this.carStateBean.acBtn == "1")
      this.loopOpen = (this.carStateBean.circulate == "1")
      this.defoggingOpen = (this.carStateBean.clearFog == "1")
      this.temIndex = parseInt(this.carStateBean.setTemp)
      this.temperature = this.temperatureList[this.temIndex]
    })
  }

  //设置温度
  async tempChange() {
    let postData = new CarStateBean()
    postData.setTemp = this.temIndex + ""
    try {
      await changeCarState(postData)
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  //设置ac开关
  async acChange() {
    let postData = new CarStateBean()
    postData.acBtn = this.acOpen ? "1" : "0"
    try {
      await changeCarState(postData)
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  //设置内外循环
  async loopChange() {
    let postData = new CarStateBean()
    postData.circulate = this.loopOpen ? "1" : "0"
    try {
      await changeCarState(postData)
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  //设置除雾
  async defoggingChange() {
    let postData = new CarStateBean()
    postData.clearFog = this.defoggingOpen ? "1" : "0"
    try {
      await changeCarState(postData)
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  //设置空调开关
  async antoChange() {
    let postData = new CarStateBean()
    postData.auto = this.autoOpen ? "1" : "0"
    try {
      await changeCarState(postData)
    } catch (e) {
      promptAction.showToast({ message: e })
    }
  }

  build() {
    Column({ space: 30 }) {
      Row() {
        Text("空调")
          .normalText(16, "#FFFFFF", FontWeight.Bold)


        Image($r("app.media.ic_switch"))
          .width(25)
          .onClick(() => {
            this.dialogController.open()
            setTimeout(() => {
              this.dialogController.close()
              this.autoOpen = !this.autoOpen
              this.antoChange()
            }, 1000)
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")

      if (this.autoOpen) {
        Column({ space: 30 }) {
          Row() {
            Row() {
              Image($r("app.media.ic_remove"))
                .width(10)
                .margin({
                  left: 10
                })

            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Start)
            .onClick(() => {
              this.dialogController.open()
              setTimeout(() => {
                this.dialogController.close()
                if (this.temIndex > 0) {
                  this.temIndex--
                  this.temperature = this.temperatureList[this.temIndex]
                  this.tempChange()
                }
              }, 2000)
            })

            Text(this.temperature + "℃")
              .normalText(16, "#FFFFFF")


            Row() {
              Image($r("app.media.ic_add"))
                .width(10)
                .margin({
                  right: 10
                })

            }
            .justifyContent(FlexAlign.End)
            .layoutWeight(1)
            .onClick(() => {
              this.dialogController.open()
              setTimeout(() => {
                this.dialogController.close()
                if (this.temIndex < this.temperatureList.length - 1) {
                  this.temIndex++
                  this.temperature = this.temperatureList[this.temIndex]
                  this.tempChange()
                }
              }, 1000)
            })

          }
          .width("65%")
          .borderRadius(999)
          .height(36)
          .backgroundColor("#2F3135")


          Row() {
            Stack() {
              Image($r("app.media.ic_loop"))
                .width(60)
                .opacity(this.loopOpen ? 0 : 1)
              Image($r("app.media.ic_loop_active"))
                .width(60)
                .opacity(this.loopOpen ? 1 : 0)
            }
            .onClick(() => {
              this.dialogController.open()
              setTimeout(() => {
                this.dialogController.close()
                this.loopOpen = !this.loopOpen
                this.loopChange()
              }, 1000)
            })

            Stack() {
              Image($r("app.media.ic_ac"))
                .width(60)
                .opacity(this.acOpen ? 0 : 1)
              Image($r("app.media.ic_ac_active"))
                .width(60)
                .opacity(this.acOpen ? 1 : 0)
            }
            .onClick(() => {
              this.dialogController.open()
              setTimeout(() => {
                this.dialogController.close()
                this.acOpen = !this.acOpen
                this.acChange()
              }, 1000)
            })

            Stack() {
              Image($r("app.media.ic_defogging"))
                .width(60)
                .opacity(this.defoggingOpen ? 0 : 1)
              Image($r("app.media.ic_defogging_active"))
                .width(60)
                .opacity(this.defoggingOpen ? 1 : 0)
            }
            .onClick(() => {
              this.dialogController.open()
              setTimeout(() => {
                this.dialogController.close()
                this.defoggingOpen = !this.defoggingOpen
                this.defoggingChange()
              }, 1000)

            })

          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width("100%")
        }
      } else {
        Column() {
          Image($r("app.media.bg_air_close"))
            .width("65%")

          Text("空 调 系 统 已 关 闭")
            .normalText(14, "#EBEBEB")
        }
        .width("100%")

      }
    }
    .width("100%")
    .backgroundColor("#1F2125")
    .borderRadius(9)
    .padding(15)
  }
}

@Extend(Text)
function normalText(fontSize: number, fontColor: string, fontWeight: FontWeight = FontWeight.Normal) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
}