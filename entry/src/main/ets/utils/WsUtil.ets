import webSocket from '@ohos.net.webSocket';
import { WS_URL } from '../http/RequestUtil';
import { StorageUtils } from './StorageUtils';

class WsUtil {
  private socket: webSocket.WebSocket = {} as webSocket.WebSocket;

  initWs(ws: webSocket.WebSocket) {
    this.socket = ws;
  }

  async connectWs() {
    let userName = await StorageUtils.get("userName", "") as string;
    await this.socket.connect(WS_URL + userName + new Date().getTime().toFixed())
  }

  onMsg(callback: Function = (str) => {
  }) {
    this.socket.on('message', (err: Error, value: string) => {
      if (err) {
        console.log("zzq",JSON.stringify(err))
      }else {
        callback(value)
      }

    })
  }

  onOpen() {
    this.socket.on('open', (err, value) => {
      console.log("on open, status:" + JSON.stringify(value));
      // 当收到on('open')事件时，可以通过send()方法与服务器进行通信
      this.socket.send("Hello, server!", (err, value) => {
        if (!err) {
          console.log("Message sent successfully");
        } else {
          console.log("Failed to send the message. Err:" + JSON.stringify(err));
        }
      });
    });
  }

  onError(callback: Function = () => {
  }) {
    this.socket.on('error', (err) => {
      console.log("on error, error:" + JSON.stringify(err))
      callback()
    });
  }

  async onWsDestroy() {
    await this.socket.close()
  }
}

let wsUtil = new WsUtil()

export default wsUtil;