import Want from '@ohos.app.ability.Want';
import tag from '@ohos.nfc.tag';
import router from '@ohos.router';

export class NFCUtils {
  static getNFCInfo(want: Want) {
    var tagInfo;
    try {
      tagInfo = tag.getTagInfo(want);
    } catch (error) {
      console.log("tag.getTagInfo catched error")
    }
    if (tagInfo == null || tagInfo == undefined) {
      console.log("no TagInfo to be created, ignore it.");
      return;
    }
    var isNfcATag = false;
    // console.log("liuwanqi" + JSON.stringify(tagInfo))
    if (tagInfo.technology) {
      (tagInfo.technology as Array<any>).forEach((v) => {
        if (v == tag.NFC_A) {
          isNfcATag = true;
        }
      })
      // for (var j = 0; j < tagInfo.technology.length; j++) {
      //   if (tagInfo.technology[j] == tag.NFC_A) {
      //     isNfcATag = true;
      //   }
      // }
      if (isNfcATag) {
        try {
          AppStorage.SetOrCreate("uid", (tagInfo['uid']).join(","))
          router.pushUrl({
            url: 'pages/nfc/NFCPage'
          })
        } catch (error) {
          console.log("tag.getNfcATag catched error: " + error);
        }
      }
    }
  }

  static hexToString(hex:string) {
    if (hex=="") {
      return "读取中...";
    }
    var list = hex.split(",")
    let str = ""
    for (var i = 0; i < list.length; i += 1) {
      str += parseInt(list[i]).toString(16)
    }
    return str ;
  }
}