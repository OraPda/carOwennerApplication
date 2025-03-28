import { StorageUtils } from '../../utils/StorageUtils'
import router from '@ohos.router'

@Entry
@Component
struct StartPage {
  onPageShow() {

    setTimeout(async () => {
      let isLogin = await StorageUtils.get("isLogin", false)

      if (isLogin) {
        if (AppStorage.Get("uid")) {
          router.replaceUrl({
            url: "pages/nfc/NFCPage"
          })
        } else {
          router.replaceUrl({
            url: "pages/Index"
          })
        }
      } else {
        router.replaceUrl({
          url: "pages/login/LoginPage"
        })
      }


    }, 2000)

  }

  build() {
    Stack() {
      Image($r("app.media.bg_start"))
        .width("100%")
        .height("100%")
      Column({ space: 30 }) {
        Image($r("app.media.ic_start"))
          .width("50%")

        Text("鸿智出行·智能出行")
          .fontSize(16)
          .fontColor("#B9C2C4")
      }
    }
    .width("100%")
    .height("100%")
  }
}