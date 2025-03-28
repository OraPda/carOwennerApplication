import { CommonTitleBar } from '../../components/Header'
import router from '@ohos.router'
import { StorageUtils } from '../../utils/StorageUtils';
import { NFCUtils } from '../../utils/NFCUtils';
import { readNFC } from '../../http/ApiGroup';
import promptAction from '@ohos.promptAction';
import LoadingDialog from '../../components/LoadingDialog';

@Entry
@Component
struct NFCPage {
  @State message: string = '';
  @State openMessage: string = '车门已打开'
  @State timer: number = -1
  @State isShow: Visibility = Visibility.Hidden
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      textValue: "正在打开",
    }),
    alignment: DialogAlignment.Center,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  onPageShow() {
    this.dialogController.open()
    clearInterval(this.timer)
    this.timer = setInterval(async () => {
      let isLogin = await StorageUtils.get("isLogin", false)
      if (isLogin && AppStorage.Get("uid") != undefined) {
        this.message = AppStorage.Get("uid")
        clearInterval(this.timer)
        try {
          let result = await readNFC(NFCUtils.hexToString(this.message))
          promptAction.showToast({ message: result['msg'] })
          this.dialogController.close()
          this.isShow = Visibility.Visible
        } catch (e) {
          promptAction.showToast({ message: e })
          this.dialogController.close()
        }
      } else {
        this.message = ""
        this.dialogController.close()
        router.replaceUrl({
          url: "pages/login/LoginPage"
        })
      }
    }, 1000)
  }

  aboutToAppear() {
    console.log("liuwanqi111")
  }

  aboutToDisappear() {
    clearInterval(this.timer)
  }

  build() {
    Column() {
      CommonTitleBar({ attribute: {
        bg_color: "",
        showLeft: true,
        closeCallback: () => {
          router.replaceUrl({
            url: 'pages/Index'
          })
        },
        title_text: "NFC信息",
        showRight: false
      } })


      Column() {
        Image($r('app.media.ic_nfc_open'))
          .width("50%")
          .margin({
            top: 78
          })
        Text(this.openMessage)
          .normalText(14,'#3D3D3D')
          .margin({
            top:46
          })
      }
      .width("100%")
      .height("100%")
      .visibility(this.isShow)
    }
    .backgroundColor("#F6FDFD")
    .backgroundImageSize({
      width: "100%",
      height: "100%"
    })
    .width("100%")
    .height("100%")
  }
}
@Extend(Text)
function normalText(fontSize: number, fontColor: string, fontWeight: FontWeight = FontWeight.Normal) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
}