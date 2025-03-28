import router from '@ohos.router'
import { register } from '../../http/ApiGroup'
import Prompt from '@system.prompt'

@Entry
@Component
struct RegisterPage {
  @State username: string = ""
  @State password: string = ""
  @State confirmPassword: string = ""
  @State showTipU: boolean = false
  @State showTipP: boolean = false
  @State showTipCP: boolean = false

  async register() {
    try {
      let result = await register({
        "nickName": this.username, //用户姓名
        "userName": this.username, //用户账号
        "phonenumber": "", //手机号码
        "sex": "2", //用户性别
        "avatar": "", //用户头像
        "password": this.password, //密码
        "roleIds": [
          "9"
        ], //角色组
        "birthDate": "",
        "state": "1"
      })
      Prompt.showToast({ message: "注册成功" })
      router.replaceUrl({
        url: "pages/login/LoginPage",
        params: {
          userName: this.username,
          password: this.password
        }
      })
    }catch (e) {
      Prompt.showToast({ message: e })
    }
  }

  isSpecial(value: string) {
    var pattern = /[!@#$%^&*()_+{}|:"<>?`~\-=\[\]\\;\',./]/;
    return pattern.test(value);
  }

  checkUserName() {
    if (this.username.length > 20 || this.isSpecial(this.username) || this.username.length < 1) {
      this.showTipU = true
    } else {
      this.showTipU = false
    }
  }

  checkPassword() {
    if (this.password.length > 20 || this.password.length < 1) {
      this.showTipP = true
    } else {
      this.showTipP = false
    }
  }

  checkPasswordCP() {
    if (this.password != this.confirmPassword) {
      this.showTipCP = true
    } else {
      this.showTipCP = false
    }
  }

  build() {
    Column() {
      Column() {
        Row().height("50%")
        Column({ space: 10 }) {
          Text("注册账号")
            .commonTextRegister("#fff", 26)
          Text("欢迎使用 车主APP!")
            .commonTextRegister("#fff", 14)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .width("80%")
        .layoutWeight(1)
      }
      .height("30%")
      .width("100%")

      Column() {
        Column({ space: 8 }) {
          TextInput({ placeholder: "请输入用户名" })
            .onChange((value) => {
              this.username = value
              this.checkUserName()
            })
            .fontColor(Color.White)
            .backgroundColor(Color.Transparent)
            .placeholderColor("#CCCCCC")
            .border({
              width: 1,
              color: "#A9ADB2"
            })
            .placeholderFont({
              size: 16
            })
            .padding({
              top: 11,
              right: 11,
              bottom: 14
            })
          Text("不能为空，长度不能超过20且不能含有特殊字符")
            .commonTextRegister("#fff", 12)
            .opacity(this.showTipU ? 1 : 0)
          TextInput({ placeholder: "请输入密码" })
            .type(InputType.Password)
            .showPasswordIcon(false)
            .fontColor(Color.White)
            .border({
              width: 1,
              color: "#A9ADB2"
            })
            .onChange((value) => {
              this.password = value
              this.checkPassword()
            })
            .backgroundColor(Color.Transparent)
            .placeholderColor("#CCCCCC")
            .placeholderFont({
              size: 16
            })
            .padding({
              top: 11,
              right: 11,
              bottom: 14
            })
          Text("不能为空，长度不能超过20")
            .commonTextRegister("#F6763F", 12)
            .opacity(this.showTipP ? 1 : 0)
          TextInput({ placeholder: "请确认密码" })
            .fontColor(Color.White)
            .type(InputType.Password)
            .border({
              width: 1,
              color: "#A9ADB2"
            })
            .showPasswordIcon(false)
            .onChange((value) => {
              this.confirmPassword = value
              this.checkPasswordCP()
            })
            .backgroundColor(Color.Transparent)
            .placeholderColor("#CCCCCC")
            .placeholderFont({
              size: 16
            })
            .padding({
              top: 11,
              right: 11,
              bottom: 14
            })
          Text("密码不一致")
            .commonTextRegister("#F6763F", 14)
            .opacity(this.showTipCP ? 1 : 0)
          Button() {
            Text("注册")
              .commonTextRegister("#FFFFFF", 18)
          }
          .height(45)
          .width("100%")
          .margin({
            top: 40
          })
          .linearGradient({
            direction: GradientDirection.Left,
            colors: [["#0B72FE", 0.0], ["#0058D0", 1.0]]
          })
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            if (!this.showTipP && !this.showTipU && !this.showTipCP) {
              this.register()
            } else {
              Prompt.showToast({ message: "请根据提示操作" })
            }
          })

          Text("登录")
            .commonTextRegister("#0B72FE", 14)
            .width("100%")
            .textAlign(TextAlign.Center)
            .onClick(() => {
              router.back()
            })
        }
        .alignItems(HorizontalAlign.Start)
        .width("80%")
        .layoutWeight(1)
      }.height("65%")
      .width("100%")

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
      .width("70%")
      .layoutWeight(1)
    }
    .backgroundImage($r('app.media.bg_login'))
    .backgroundImageSize({
      width: "100%",
      height: "100%"
    })
    .width("100%")
    .height('100%')
  }
}

@Extend(Text)
function commonTextRegister(fontColor: string, size: number, fontWeight: FontWeight = FontWeight.Normal) {
  .fontColor(fontColor)
  .fontSize(size)
  .fontWeight(fontWeight)
}