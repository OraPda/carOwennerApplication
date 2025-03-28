import { CommonTitleBar } from '../../components/Header'
import router from '@ohos.router'
import { getLogList } from '../../http/ApiGroup'
import promptAction from '@ohos.promptAction'
import LoadingDialog from '../../components/LoadingDialog'

@Entry
@Component
export default struct MessagePage {
  @State messageList: Array<messageInfo> = []
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      textValue: "加载中..",
    }),
    alignment: DialogAlignment.Center,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })
  private pageNum: number = 1;

  onPageShow() {
    this.getLogList()
  }

  async getLogList() {
    this.dialogController.open()
    try {
      let logList = await getLogList(this.pageNum)
      this.dialogController.close()
      this.messageList =  [...logList["rows"],...this.messageList]
    } catch (e) {
      this.dialogController.close()
      promptAction.showToast({ message: e })
    }
  }

  build() {
    Column() {
      CommonTitleBar({ attribute: {
        showLeft: true,
        closeCallback: () => {
          router.back()
        },
        title_text: "信息",
        showRight: false
      } })

      Column() {
        Column() {
          List({ space: 20 }) {
            ForEach(this.messageList, (item: messageInfo, index: number) => {
              ListItem() {
                Column({ space: 10 }) {
                  Text(item.operaType)
                    .normalText(16, "#FFFFFF")
                  Text(item.operaContent)
                    .normalText(14, "#FFFFFF")
                  Text(item.createTime)
                    .normalText(12, "#9C9C9C")
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
            })
          }
          .divider({ strokeWidth: 0.5, color: "#D8D8D8" }).layoutWeight(1) // 每行之间的分界线
          .onReachEnd(() => {
            this.pageNum++
            this.getLogList()
          })
        }.margin(15)
      }
      .layoutWeight(1)
      .margin(10)
    }
    .backgroundColor("#101010")
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

class messageInfo {
  id: number
  operaType: string
  operaContent: string
  createTime: string
}