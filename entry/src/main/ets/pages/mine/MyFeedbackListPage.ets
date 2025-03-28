import { CommonTitleBar } from '../../components/Header'
import router from '@ohos.router'
import { changeFbStatus, getFbList } from '../../http/ApiGroup'
import LoadingDialog from '../../components/LoadingDialog'
import FeedbackInfoBean from '../../viewmodel/FeedbackInfoBean'

@Entry
@Component
struct MyFeedbackListPage {
  @State fbList: Array<FeedbackInfoBean> = [];
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      textValue: "加载中..",
    }),
    alignment: DialogAlignment.Center,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  async onPageShow() {
    this.dialogController.open()
    let list = await getFbList()
    this.fbList = list["data"]
    this.dialogController.close()
  }

  async goDetail(item: FeedbackInfoBean) {
    if (item.replyRead == "1") {
      await changeFbStatus({
        "id": item.id, //自增主键
        "replyRead": "2"
      })
    }
    router.pushUrl({
      url: "pages/mine/FeedbackDetailPage",
      params: {
        createTime: item.createTime,
        updateTime: item.updateTime,
        nickName: item.nickName,
        content: item.content,
        picUrl: item.picUrl,
        reply: item.reply,
        updateBy: item.updateBy,
      }
    })
  }

  build() {
    Column() {
      CommonTitleBar({ attribute: {
        showLeft: true,
        bg_color: "#1A1B24",
        closeCallback: () => {
          router.back()
        },
        title_text: "我的反馈",
        showRight: false
      } })

      Column() {
        List() {
          ForEach(this.fbList, (item: FeedbackInfoBean, index) => {
            ListItem() {
              Column({ space: 8 }) {
                Badge({ value: '',
                  style: { badgeSize: item.replyRead == "1" ? 6 : 0, badgeColor: '#FA2A2D' } }) {

                  Text(item.content)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .commonText(12, "#FFFFFF")
                    .width("100%")
                }

                Text(item.createTime)
                  .commonText(12, "#9C9C9C")
              }
              .alignItems(HorizontalAlign.Start)
              .padding({
                top: 15,
                bottom: 15
              })
              .border({
                width: { bottom: 1 },
                color: "#2F2F2F"
              })
              .width("100%")
            }
            .onClick(() => this.goDetail(item))
          })

        }
        .width("100%")
        .padding({
          top: 10,
          left: 15,
          right: 15
        })
        .layoutWeight(1)

        Row() {
          Text("新建反馈")
            .width("100%")
            .textAlign(TextAlign.Center)
            .padding(10)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor("#0B72FE")
            .borderRadius(9999)
            .onClick(()=>{
              router.pushUrl({
                url: "pages/mine/SubmitFeedbackPage"
              })
            })
        }
        .justifyContent(FlexAlign.Center)
        .width("100%")
        .padding({
          top: 10,
          left: 15,
          right: 15,
          bottom:10
        })
        .backgroundColor("#181A1E")

      }
      .backgroundColor("#101010")
      .width('100%')
      .layoutWeight(1)
    }
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