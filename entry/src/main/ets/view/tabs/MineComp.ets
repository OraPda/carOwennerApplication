import router from '@ohos.router'
import { getUserInfoById } from '../../http/ApiGroup'
import Prompt from '@system.prompt'
import { BASE_URL } from '../../http/RequestUtil'
import emitter from '@ohos.events.emitter'
import { StorageUtils } from '../../utils/StorageUtils'
import LoadingDialog from '../../components/LoadingDialog'


/**
 * 我的意见
 * @author yang
 * @Date 2024.07.27
 */
@Preview
@Component
export default struct MineComp {
  @State nickName: string = ""
  @State avatar: string = ""
  @State birthDate: string = ""
  @State sex: string = ""
  @State userId: string = ""
  @State userName: string = ""
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      textValue: "退出中",
    }),
    alignment: DialogAlignment.Center,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  async aboutToAppear() {
    try {
      let userInfo = await getUserInfoById()
      console.log(JSON.stringify(userInfo))
      this.nickName = userInfo["data"]["nickName"]
      this.avatar = userInfo["data"]["avatar"]
      this.birthDate = userInfo["data"]["birthDate"]
      this.sex = userInfo["data"]["sex"]
      this.userId = userInfo["data"]["userId"]
      this.userName = userInfo["data"]["userName"]
    } catch (e) {
      Prompt.showToast({ message: e })
    }

    emitter.on({
      eventId: 0
    }, (data) => {
      this.nickName = data.data!["nickName"]
      this.birthDate = data.data!["birthDate"]
      this.avatar = data.data!["avatar"]
      this.sex = data.data!["sex"]
    })
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.ic_mine_edit"))
          .width(20)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/mine/PersonalInfoPage',
              params: {
                nickName: this.nickName,
                avatar: this.avatar,
                birthDate: this.birthDate,
                sex: this.sex,
                userId: this.userId,
                userName: this.userName
              }
            })
          })

      }
      .justifyContent(FlexAlign.End)
      .width("100%")
      .margin({
        bottom:50
      })

      Column({ space: 12 }) {
        Image((this.avatar == "" || this.avatar == null) ? $r("app.media.ic_user_avatar") : BASE_URL + this.avatar)
          .width(80)
          .height(80)
          .borderRadius(99999)
        Column({ space: 5 }) {
          Text(this.nickName)
            .normalText(18, "#FFFFFF")
          Text(this.birthDate)
            .normalText(12, "#B8B8B8")
        }
        .alignItems(HorizontalAlign.Start)
      }


      Column({ space: 15 }) {



        // Row() {
        //   Row({ space: 10 }) {
        //     Image($r("app.media.ic_binding_car"))
        //       .width(40)
        //
        //     Column({ space: 4 }) {
        //       Text("绑定车辆")
        //         .normalText(16, "#222")
        //       Text("点击这里进行车架号绑定")
        //         .normalText(12, "#999")
        //     }
        //     .alignItems(HorizontalAlign.Start)
        //   }
        //
        //   Image($r("app.media.ic_right"))
        //     .width(8)
        // }
        // .onClick(() => {
        //   router.pushUrl({
        //     url: 'pages/mine/BindCarPage'
        //   })
        // })
        // .optionItem()
        //
        // Row() {
        //   Row({ space: 10 }) {
        //     Image($r("app.media.ic_feedback"))
        //       .width(40)
        //
        //     Column({ space: 4 }) {
        //       Text("我的反馈")
        //         .normalText(16, "#222")
        //       Text("点击这里进行反馈建议填写")
        //         .normalText(12, "#999")
        //     }
        //     .alignItems(HorizontalAlign.Start)
        //   }
        //
        //   Image($r("app.media.ic_right"))
        //     .width(8)
        // }
        // .optionItem()
        // .onClick(() => {
        //   router.pushUrl({
        //     url: "pages/mine/MyFeedbackListPage"
        //   })
        // })


        Row() {
          Column({space:10}){
            Image($r("app.media.ic_binding_car"))
              .width(30)

            Text("绑定车辆")
              .normalText(14,"#FFFFFF")
          }
          .layoutWeight(1)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/mine/BindCarPage'
            })
          })

          Column({space:10}){
            Image($r("app.media.ic_feedback"))
              .width(30)

            Text("我的反馈")
              .normalText(14,"#FFFFFF")
          }
          .layoutWeight(1)
          .onClick(() => {
            router.pushUrl({
              url: "pages/mine/MyFeedbackListPage"
            })
          })

          Text()
            .layoutWeight(1)
          Text()
            .layoutWeight(1)
        }
        .optionItem()
        .margin({
          top:30
        })

        Row(){
          Button("退出登录")
          .height(45)
          .width("100%")
          .backgroundColor("#0B72FE")
          .onClick(async () => {
            AlertDialog.show(
              {
                title: '提示',
                message: '是否退出',
                autoCancel: true,
                alignment: DialogAlignment.Center,
                gridCount: 4,
                offset: { dx: 0, dy: -20 },
                primaryButton: {
                  value: '取消',
                  action: () => {
                    console.info('Callback when the first button is clicked')
                  },
                  fontColor:Color.Grey
                },
                secondaryButton: {
                  value: '确定',
                  action: () => {
                    this.dialogController.open()
                    setTimeout(() => {
                      StorageUtils.clearInfo()
                      this.dialogController.close()
                      router.clear()
                      router.replaceUrl({
                        url: "pages/login/LoginPage"
                      })
                    },1000)
                  },
                  fontColor:Color.Red
                },
                cancel: () => {
                }
              }
            )
          })
        }
        .layoutWeight(1)
        .margin({
          bottom: -60
        })
      }
    }
    .width("100%")
    .backgroundImage($r("app.media.bg_mine"))
    .height("100%")
    .backgroundImageSize({
      width: "100%",
      height: "100%"
    })
    .padding({
      left: 20,
      right: 20,
      top: 30
    })
  }
}

@Extend(Text)
function normalText(fontSize: number, fontColor: string, fontWeight: FontWeight = FontWeight.Normal) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
}

@Extend(Row)
function optionItem() {
  .backgroundColor("#0fFFFFFF")
  .border({
    color:"#70FFFFFF"
  })
  .justifyContent(FlexAlign.SpaceBetween)
  .width("100%")
  .padding({
    left: 10,
    right: 10,
    top: 30,
    bottom:30
  })
  .borderRadius(6)
}
