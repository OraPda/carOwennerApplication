@Preview
@CustomDialog
export default struct ChooseImageSourceDialog {
  controller: CustomDialogController
  fromCamera: () => void
  fromAlbum: () => void

  build() {
    Column() {
      Column() {
        // Text("拍照")
        //   .fontSize(14)
        //   .fontColor("#333333")
        //   .width("100%")
        //   .textAlign(TextAlign.Center)
        //   .border({ width: { bottom: 1 }, color: "#EAEBED" })
        //   .padding({
        //     top: 15,
        //     bottom: 15
        //   })
        //   .onClick(() => this.fromCamera())

        Text("选择一张照片")
          .fontSize(14)
          .fontColor("#333333")
          .width("100%")
          .textAlign(TextAlign.Center)
          .padding({
            top: 15,
            bottom: 15
          })
          .onClick(() => this.fromAlbum())
      }
      .padding({
        left: 10,
        right: 10
      })

      Text("取消")
        .width("100%")
        .padding(15)
        .textAlign(TextAlign.Center)
        .fontColor("#333333")
        .fontSize(16)
        .border({ width: { top: 3 }, color: "#F1F4F9" })
        .onClick(() => {
          this.controller.close()
        })


    }
    .backgroundColor("#fff")
    .borderRadius({ topLeft: 16, topRight: 16 })
  }
}
