import { CommonTitleBar } from '../../components/Header'
import router from '@ohos.router'
import { BASE_URL } from '../../http/RequestUtil'
import { getImagePath, updateUser, uploadUrl } from '../../http/ApiGroup'
import Prompt from '@system.prompt'
import { StorageUtils } from '../../utils/StorageUtils'
import request from '@ohos.request'
import common from '@ohos.app.ability.common'
import { MediaBean } from '../../viewmodel/MediaBean'
import { MediaHelper } from '../../utils/MediaHelper'
import ChooseImageSourceDialog from '../../components/ChooseImageSourceDialog'
import fs from '@ohos.file.fs';
import emitter from '@ohos.events.emitter'
import promptAction from '@ohos.promptAction'

@Entry
@Component
export default struct PersonalInfo {
  private sexs: string[] = ['男', '女', "未知"]
  private sexValues: string[] = ['0', '1', "2"]
  @State userId: string = ""
  @State sexName: string = ""
  @State selectSexIndex: number = 0
  @State birthday: string = '1997-03-25'
  @State selectedDate: number = new Date().getTime()
  @State nickName: string = ""
  @State userName: string = ""
  @State avatar: string = ""
  @State birthDate: string = ""
  @State sex: string = ""
  private context = getContext(this) as common.UIAbilityContext;
  @State mediaBean: MediaBean = new MediaBean();
  private mediaHelper: MediaHelper = new MediaHelper(getContext());
  // 上传头像 参数
  @State fileName: string = ""
  // @State imagePath: string = "";

  dialogController: CustomDialogController = new CustomDialogController({
    builder: ChooseImageSourceDialog({
      fromCamera: this.fromCamera.bind(this),
      fromAlbum: this.fromAlbum.bind(this)
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

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

  async fromCamera() {
    this.fileName = new Date().getTime() + ""
    let cacheDir = this.context.cacheDir;
    let mediaBean: MediaBean;
    mediaBean = await this.mediaHelper.takePhoto(this.context);
    if (mediaBean) {
      this.mediaBean = mediaBean;
    }

    // this.imagePath = ""
    this.dialogController.close()
  }

  async getImagePath() {
    let result = await getImagePath({
      "fileName": this.fileName + ".jpg"
    })
    // this.imagePath = result["data"]["filePath"]
    this.avatar = result["data"]["filePath"]
    console.log(JSON.stringify(result))

  }
  // 上传头像
  async uploadImage() {
    let uploadConfig = {
      url: uploadUrl,
      method: 'POST',
      header: {
        'Content-Type': "multipart/form-data",
        "Authorization": await StorageUtils.get("token")
      },
      files: [
        { filename: `${this.fileName}.jpg`, name: 'file', uri: `internal://cache/${this.fileName}.jpg`, type: 'jpg' }
      ],
      data: []
    }
    // 将本地应用文件上传至网络服务器D325676
    try {
      request.uploadFile(this.context, uploadConfig)
        .then((uploadTask) => {
          let upProgressCallback = (uploadedSize, totalSize) => {
            console.info("upload totalSize:" + totalSize + "  uploadedSize:" + uploadedSize);
            if (totalSize > 512778) {
              promptAction.showToast({message: "图片不能超过500kb"})
              uploadTask.delete()
              return
            }
          };
          uploadTask.on('progress', upProgressCallback);
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
  aboutToAppear() {
    this.birthday = router.getParams()["birthDate"]
    this.selectSexIndex = parseInt(router.getParams()["sex"])
    this.sexName = this.sexs[this.selectSexIndex]
    this.selectedDate = new Date(this.birthday).getTime()
    this.nickName = router.getParams()["nickName"]
    this.avatar = router.getParams()["avatar"]
    this.userId = router.getParams()["userId"]
    this.userName = router.getParams()["userName"]
  }

  async updateUser() {
    try {
      await updateUser({
        "nickName": this.nickName, //用户姓名
        "sex": this.sex, //用户性别
        "avatar": this.avatar, //用户头像
        "birthDate": this.birthday, //出生日期
        "userId": this.userId,
        "userName": this.userName
      })
      Prompt.showToast({ message: "修改成功" })
      emitter.emit({
        eventId:0
      },{
        data:{
          "nickName": this.nickName, //用户姓名
          "sex": this.sex, //用户性别
          "avatar": this.avatar, //用户头像
          "birthDate": this.birthday, //出生日期
          "userId": this.userId,
          "userName": this.userName
        }
      })
    } catch (e) {
      Prompt.showToast({ message: e })
    }
  }

  build() {
    Column() {
      CommonTitleBar({ attribute: {
        showLeft: true,
        bg_color:"#1A1B24",
        closeCallback: () => {
          router.back()
        },
        title_text: "个人信息",
        showRight: false
      } })

      Column() {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Image((this.avatar == "" || this.avatar == null) ? $r("app.media.ic_user_avatar") : BASE_URL + this.avatar)
            .width(80)
            .height(80)
            .borderRadius(400)
          Image($r("app.media.ic_camera"))
            .width(30)
        }
        .margin({
          top: 20
        })
        .onClick(() => this.dialogController.open())
      }
      .height("20%")
      .width("100%")

      Column() {

        Row() {
          Text("昵称")
            .normalText(14, "#E2E2E2")
            .layoutWeight(1)
          TextInput({ text: this.nickName })
            .width(100)
            .textAlign(TextAlign.End)
            .style(TextInputStyle.Inline)
            .backgroundColor(Color.Transparent)
            .padding({})
            .fontColor("#E2E2E2")
            .borderRadius(0)
            .onChange((val) => {
              this.nickName = val
            })
          // .normalText(14,"#222222")
        }
        .rowItem()

        Row() {
          Text("性别")
            .normalText(14, "#E2E2E2")
            .layoutWeight(1)
          Text(this.selectSexIndex == 0 ? '男' : this.selectSexIndex == 1 ? "女" : "未知")
            .normalText(14, "#E2E2E2")
        }
        .onClick(() => {
          TextPickerDialog.show({
            range: this.sexs,
            selected: this.selectSexIndex,
            onAccept: (value: TextPickerResult) => {
              // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
              this.selectSexIndex = value.index
              this.sex = this.sexValues[this.selectSexIndex]
            },
            onCancel: () => {
            },
            onChange: (value: TextPickerResult) => {
            }
          })
        })
        .rowItem()

        Row() {
          Text("出生日期")
            .normalText(14, "#E2E2E2")
            .layoutWeight(1)
          Text(this.birthday)
            .normalText(14, "#E2E2E2")
        }
        .height(40)
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date("1888-08-08"),
            end: new Date("2100-12-31"),
            selected: new Date(this.selectedDate),
            onAccept: (value: DatePickerResult) => {
              // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
              // this.selectedDate.setFullYear(value.year, value.month, value.day)
              let selectDate = new Date()
              selectDate.setFullYear(value.year, value.month, value.day)
              this.selectedDate = selectDate.getTime()
              let month = ""
              let day = ""
              if (value.month < 10) {
                month = "0" + (value.month + 1)
                console.log(month)
              } else {
                month = "" + (value.month + 1)
              }
              if (value.day < 10) {
                day = "0" + value.day
              } else {
                day = "" + value.day
              }
              this.birthday = value.year + "-" + month + "-" + day
            },
            onCancel: () => {
              // console.info("DatePickerDialog:onCancel()")
            },
            onChange: (value: DatePickerResult) => {
              // console.info("DatePickerDialog:onChange()" + JSON.stringify(value))
            }
          })
        })

        Row() {
          Text("保存")
            .normalText(14, "#FFFFFF")
        }
        .justifyContent(FlexAlign.Center)
        .width("100%")
        .padding(10)
        .backgroundColor("#0B72FE")
        .borderRadius(9999)
        .margin({
          top: "70%"
        })
        .onClick(()=>this.updateUser())
      }
      .width("100%")
      .height("100%")
      .layoutWeight(1)
      .padding({
        top: 20,
        left: 25,
        right: 25
      })
    }
    .backgroundImage($r("app.media.bg_car_control"))
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

@Extend(Row)
function rowItem() {
  .justifyContent(FlexAlign.SpaceBetween)
  .border({
    width: {
      bottom: 1,
    },
    color: "#2F2F2F"
  })
  .height(40)
}
