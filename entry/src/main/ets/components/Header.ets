
@Component
export struct CommonTitleBar {
  // 标题栏属性
  public attribute: CommonTitleBarAttribute;

  build() {
    Flex() {
      Stack({ alignContent: Alignment.Start }) {
        Image($r('app.media.ic_back'))
          .width(20)
          .onClick(() => {
            this.attribute.closeCallback?.call(this)
          })
      }
      .padding({ left: 15 })
      .height("100%")
      .layoutWeight(1)
      .visibility(this.attribute.showLeft ? Visibility.Visible : Visibility.Hidden)

      Stack({ alignContent: Alignment.Center }) {
        Text(this.attribute.title_text)
          .fontSize(16)
          .fontColor('#FFFFFF')
          // .width(60)
          .textAlign(TextAlign.Center)
          .height('100%')
      }
      .layoutWeight(2)

      Stack({ alignContent: Alignment.End }) {
        Text("新建反馈")
          .fontSize(14)
          .fontColor("#5CD8D8")
          .onClick(() => {

            this.attribute.menuCallback?.call(this)


          })
      }
      .padding({ right: 15 })
      .height('100%')
      .visibility(this.attribute.showRight ? Visibility.Visible : Visibility.Hidden)
      .layoutWeight(1)
    }
    .width('100%')
    .height(48)
    .backgroundColor(this.attribute.bg_color)
    // .border({ color: "#ffD8D8D8", width: 1, style: BorderStyle.Solid })
  }
}

// 定义标题栏属性
class CommonTitleBarAttribute {
  public bg_color?: string = "#1A1B24"; // 标题栏背景色

  // public close_text: string = ""; // 关闭按钮文字
  public closeCallback: () => void; // 关闭按钮事件回调

  public title_text: string = ""; // 标题文字

  public menuCallback?: () => void; // 菜单按钮事件回调

  public showRight: boolean; // 是否显示右侧菜单栏

  public showLeft: boolean; // 是否显示左边
}