import call from '@ohos.telephony.call'

@Preview
@CustomDialog
export default struct LoadingDialog {
  @Prop textValue: string
  controller: CustomDialogController
  build() {
    Column() {
      LoadingProgress()
        .color("#0B72FE")
        .width(80).height(80)
      Text(this.textValue)
        .fontSize(14)
        .fontColor("#0B72FE")
    }
    .backgroundColor("#1F2125")
    .padding({ bottom: 10, top: 10, left: 20, right: 20 })
    .borderRadius(10)
  }
}