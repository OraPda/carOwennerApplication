import router from '@ohos.router'
import LoadingDialog from '../../components/LoadingDialog'
import { login,getUserInfo } from '../../http/ApiGroup'
import Prompt from '@system.prompt'
import { StorageUtils } from '../../utils/StorageUtils'

@Entry
@Component
struct LoginPage {
  @State username: string = "zzq1234"
  @State password: string = "666666"
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      textValue: "加载中..",
    }),
    alignment: DialogAlignment.Center,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  async login() {

    this.dialogController.open()
    try {
      let loginResult = await login({
        username: this.username,
        password: this.password
      })
      await StorageUtils.put("token", loginResult["token"])

      let userInfo = await getUserInfo()
      this.dialogController.close()
      if (userInfo["carId"]==""|| userInfo["carVin"]=="") {
        await StorageUtils.put("isLogin", false)
        router.replaceUrl({
          url: "pages/mine/BindCarPage"
        })
        return
      }
      await StorageUtils.put("isLogin", true)
      await StorageUtils.put("carId",userInfo["carId"])
      await StorageUtils.put("userId",userInfo["user"]["userId"])
      await StorageUtils.put("userId",userInfo["user"]["userId"])
      await StorageUtils.put("avatar",userInfo["user"]["avatar"])
      await StorageUtils.put("userName",userInfo["user"]["userName"])
      await StorageUtils.put("carVin",userInfo["carVin"])
      router.replaceUrl({
        url: "pages/Index"
      })
    } catch (e) {
      this.dialogController.close()
      Prompt.showToast({ message: e })
    }

  }

  build() {
    Column() {
      Column() {
        Row()
          .height("50%")
        Column({ space: 10 }) {
          Text("车主智能出行APP")
            .commonText("#fff", 26,FontWeight.Bold)
          Text("欢迎登录使用！")
            .commonText("#FFFFFF", 14)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .width("80%")
        .layoutWeight(1)
      }
      .commonColumn("100%", "30%")

      Column() {
        Column({ space: 20 }) {
          TextInput({ placeholder: "请输入用户名", text: this.username })
            .backgroundColor(Color.Transparent)
            .placeholderColor("#CCCCCC")
            .placeholderFont({
              size: 16
            })
            .fontColor(Color.White)
            .border({
              width: 1,
              color: "#A9ADB2"
            })
            .padding({
              top: 11,
              right: 11,
              bottom: 14
            })
            .onChange((val) => {
              this.username = val
            })
          TextInput({ placeholder: "请输入密码", text: this.password })
            .type(InputType.Password)
            .placeholderColor("#CCCCCC")
            .fontColor(Color.White)
            .border({
              width: 1,
              color: "#A9ADB2"
            })
            .backgroundColor(Color.Transparent)
            .placeholderFont({
              size: 16
            })
            .padding({
              top: 11,
              right: 11,
              bottom: 14
            })
            .onChange((val) => {
              this.password = val
            })
            .backgroundColor(Color.Transparent)
            .showPasswordIcon(true)
          Row() {
            Column().layoutWeight(1)
            Text("忘记密码?")
              .commonText("#0B72FE", 14)
          }.justifyContent(FlexAlign.SpaceBetween)

          Button() {
            Text("登录")
              .commonText("#FFFFFF", 18)
          }
          .height(45)
          .width("100%")
          .margin({
            top: 65
          })
          .linearGradient({
            direction: GradientDirection.Left,
            colors: [["#0B72FE", 0.0], ["#0058D0", 1.0]]
          })
          .backgroundColor(Color.Transparent)
          .onClick(() => this.login())

          Column() {
            Text("注册")
              .commonText("#0B72FE", 14)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/login/RegisterPage'
                })
              })
          }.alignItems(HorizontalAlign.Center)
          .width("100%")
        }
        .alignItems(HorizontalAlign.Start)
        .padding({
          left: 30,
          right: 30
        })
        .layoutWeight(1)
      }
      .commonColumn("100%", "65%")

      Column() {
        Row() {
          Toggle({ type: ToggleType.Checkbox, isOn: true })
            .size({ height: 12 })
            .selectedColor('#0B72FE')
            .onChange((isOn: boolean) => {
              console.info('Component status:' + isOn)
            })
          Text() {
            Span("同意")
              .fontSize(12)
              .fontColor("#999999")
            Span("《用户协议和隐私政策》")
              .fontColor("#526161")
              .fontSize(12)
          }
        }
      }
      .layoutWeight(1)
    }
    .backgroundImage($r('app.media.bg_login'))
    .backgroundImageSize({
      width: "100%",
      height: "100%"
    })
    .commonColumn("100%", "100%")
  }
}

@Extend(Text)
function commonText(fontColor: string, size: number, fontWeight: FontWeight = FontWeight.Normal) {
  .fontColor(fontColor)
  .fontSize(size)
  .fontWeight(fontWeight)
}

@Extend(Column)
function commonColumn(width: string | number, height: string | number) {
  .width(width)
  .height(height)
}