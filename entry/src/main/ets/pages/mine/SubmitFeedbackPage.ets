import { CommonTitleBar } from "../../components/Header"
import router from '@ohos.router';
import Prompt from '@system.prompt';
import ChooseImageSourceDialog from "../../components/ChooseImageSourceDialog"
import { MediaHelper } from '../../utils/MediaHelper';
import common from '@ohos.app.ability.common';
import { MediaBean } from "../../viewmodel/MediaBean"
import fs from '@ohos.file.fs';
import { addFeedback, getImagePath, uploadUrl } from '../../http/ApiGroup';
import { StorageUtils } from '../../utils/StorageUtils';
import request from '@ohos.request';
import { BASE_URL } from '../../http/RequestUtil';
import inputMethod from '@ohos.inputMethod';

@Entry
@Component
struct SubmitFeedbackPage {
  @State message: string = ''
  controller: TextAreaController = new TextAreaController()
  @State imagePath: string = "";
  private mediaHelper: MediaHelper = new MediaHelper(getContext());
  private context = getContext(this) as common.UIAbilityContext;
  @State mediaBean: MediaBean = new MediaBean();
  @State fileName: string = ""
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ChooseImageSourceDialog({
      fromCamera: this.fromCamera.bind(this),
      fromAlbum: this.fromAlbum.bind(this)
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  async getImagePath() {
    let result = await getImagePath({
      "fileName": this.fileName + ".jpg"
    })
    this.imagePath = result["data"]["filePath"]
    console.log(JSON.stringify(result))

  }

  async uploadImage() {
    console.log("11111")
    let uploadConfig = {
      url: uploadUrl,
      method: 'POST',
      header: {
        'Content-Type': "multipart/form-data",
        "Authorization": await StorageUtils.get("token"),
      },
      files: [
        { filename: `${this.fileName}.jpg`, name: 'file', uri: `internal://cache/${this.fileName}.jpg`, type: 'jpg' }
      ],
      data: [],
    }
    // 将本地应用文件上传至网络服务器D325676
    try {

      request.uploadFile(this.context, uploadConfig)
        .then((uploadTask) => {
          uploadTask.on('complete', (taskStates) => {
            console.log(JSON.stringify(taskStates[0]))
            this.getImagePath()
          });
        })
        .catch((err) => {
          console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
        })
    } catch (err) {
      console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);

    }
  }

  async fromAlbum() {
    this.fileName = new Date().getTime() + ""
    let cacheDir = this.context.cacheDir;
    let mediaBean: MediaBean;
    mediaBean = await this.mediaHelper.selectPicture();
    if (mediaBean) {
      this.mediaBean = mediaBean;
    }
    let file = fs.openSync(this.mediaBean.localUrl, fs.OpenMode.CREATE);
    fs.copyFileSync(file.fd, cacheDir + `/${this.fileName}.jpg`)
    this.uploadImage()
    this.dialogController.close()

  }

  async addFeedback() {

    inputMethod.getController().stopInputSession()
    try {
      if (this.message == ""){
        throw "请填写反馈内容"; //
      }
      if (this.message.length > 100) {
        throw "反馈内容在100字以内"; //
      }
      await addFeedback({
        content: this.message,
        picUrl: this.imagePath
      })
      Prompt.showToast({ message: "意见反馈成功" })
      this.message = ""
      this.imagePath = ""
    } catch (e) {
      Prompt.showToast({ message: e })
    }

  }

  async fromCamera() {
    this.fileName = new Date().getTime() + ""
    let cacheDir = this.context.cacheDir;
    let mediaBean: MediaBean;
    mediaBean = await this.mediaHelper.takePhoto(this.context);
    if (mediaBean) {
      this.mediaBean = mediaBean;
    }
    let file = fs.openSync(this.mediaBean.localUrl, fs.OpenMode.CREATE);
    fs.copyFileSync(file.fd, cacheDir + `/${this.fileName}.jpg`)
    this.uploadImage()
    this.dialogController.close()
  }

  build() {
    Column() {
      CommonTitleBar({ attribute: {
        showLeft: true,
        bg_color:"#1A1B24",
        closeCallback: () => {
          router.back()
        },
        title_text: "反馈建议",
        showRight: false
      } })

      Column() {

        Column() {
          TextArea({
            placeholder: '请输入您的反馈建议（100字以内）',
            controller: this.controller,
            text: this.message
          })
            .placeholderFont({ size: 14, })
            .placeholderColor("#999")
            .width("100%")
            .height(150)
            .padding(0)
            .backgroundColor(Color.Transparent)
            .borderRadius(0)
            .fontSize(16)
            .fontColor('#222222')
            .onChange((value: string) => {
              if (this.message.length > 100) {
                Prompt.showToast({ message: "内容最多输入200字" })
                this.message = value.substring(0, 200)
              } else {
                this.message = value
              }
            })

          if (this.imagePath.length > 0) {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(BASE_URL + this.imagePath)
                .width(90)
                .height(90)
                .borderRadius(2)
              Image($r("app.media.ic_delete_image"))
                .width(14)
                .onClick(() => {
                  this.imagePath = "";
                })
            }
          } else {
            Image($r("app.media.bg_add_image"))
              .width(90)
              .onClick(() => this.dialogController.open())
          }


        }
        .backgroundColor("#1F2125")
        .padding(15)
        .alignItems(HorizontalAlign.Start)
        .borderRadius(12)
        .width("100%")


        Text("提交")
          .margin({
            top: 90
          })
          .normalText(14, Color.White)
          .width("100%")
          .textAlign(TextAlign.Center)
          .padding(10)
          .backgroundColor("#0B72FE")
          .borderRadius(9999)
          .onClick(() => this.addFeedback())

      }
      .layoutWeight(1)
      .padding(15)
    }
    .width('100%')
    .backgroundColor("#101010")
    .height('100%')
  }
}

@Extend(Text)
function normalText(fontSize: number, fontColor: ResourceColor, fontWeight: FontWeight = FontWeight.Normal) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
}
