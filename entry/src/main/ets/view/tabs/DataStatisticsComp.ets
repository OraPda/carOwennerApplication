import web_webview from '@ohos.web.webview'
import { statistics } from '../../http/ApiGroup';


/**
 * 数据处理
 * @author yang
 * @Date 2024.07.23
 */
@Component
export default struct DataStatisticsComp {
  controller: web_webview.WebviewController = new web_webview.WebviewController();

  build() {
    Column() {
      Web({ src: $rawfile("chart.html"), controller: this.controller })
        .javaScriptAccess(true)
        .onPageEnd((e) => {
          statistics().then((res) => {
            this.controller.runJavaScript(`initChart(${JSON.stringify(res["data"])})`);
          })
        })

    }
    .width("100%")
    .height("100%")
    // .backgroundColor("#101010")
  }
}