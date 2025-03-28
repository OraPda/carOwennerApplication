import { CommonTitleBar } from '../../components/Header'
import router from '@ohos.router'
import { StorageUtils } from '../../utils/StorageUtils';
import { BASE_URL } from '../../http/RequestUtil';

@Entry
@Component
struct FeedbackDetailPage {
  @State avatar: string = "";

  async onPageShow() {
    this.avatar = await StorageUtils.get("avatar", "") as unknown as string;
    console.log(this.avatar)
  }

  build() {
    Column() {
      CommonTitleBar({ attribute: {
        showLeft: true,
        bg_color:"#1A1B24",
        closeCallback: () => {
          router.back()
        },
        title_text: "反馈详情",
        showRight: false
      } })

      Column() {
        Row({ space: 8 }) {
          Image(this.avatar == "" ? $r("app.media.ic_user_avatar") : BASE_URL + this.avatar)
            .width(33)
            .height(33)
            .borderRadius(9999)

          Column() {
            Text(router.getParams()["nickName"])
              .commonText(12, "#FFFFFF",FontWeight.Bold)

            Text(router.getParams()["createTime"])
              .commonText(12, "#959595")
          }
          .height(33)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width("100%")

        Text(router.getParams()["content"])
          .fontSize(14)
          .fontColor( "#FFFFFF")
          .width("100%")
          .margin({
            top: 10
          })

        if (router.getParams()["picUrl"] != "") {
          Image(BASE_URL + router.getParams()["picUrl"])
            .width(150)
            .height(150)
            .borderRadius(6)
            .margin({
              top: 15
            })
        }


      }
      .width("100%")
      .alignItems(HorizontalAlign.Start)
      .padding(15)
      .backgroundColor("#101010")

      Row()
        .backgroundColor("#2F2F2F")
        .width("100%")
        .height(5)

      if (router.getParams()["reply"]) {
        Column() {
          Row({ space: 8 }) {
            Image($r("app.media.ic_customer"))
              .width(33)
              .height(33)
              .borderRadius(9999)

            Column() {
              Text(router.getParams()["updateBy"])
                .commonText(12, "#fff",FontWeight.Bold)

              Text(router.getParams()["updateTime"])
                .commonText(12, "#959595")
            }
            .height(33)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width("100%")

          Text(router.getParams()["reply"])
            .fontSize(14)
            .fontColor("#fff")
            .width("100%")
            .margin({
              top: 10
            })
        }
        .width("100%")
        .alignItems(HorizontalAlign.Start)
        .padding(15)
      }
    }
    .backgroundColor("#101010")
    .width('100%')
    .height('100%')
  }
}


@Extend(Text)
function commonText(size: number, fontColor: string, fontWeight: FontWeight = FontWeight.Normal) {
  .fontColor(fontColor)
  .fontSize(size)
  .fontWeight(fontWeight)
}