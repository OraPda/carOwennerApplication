import http from '@ohos.net.http';
import { StorageUtils } from '../utils/StorageUtils';
import router from '@ohos.router';


export const BASE_URL: string = 'http://192.168.88.101:8088'; //这里写接口地址

export const WS_URL: string = 'ws://192.168.88.101:8088/webSocket/'; //这里写接口地址

export const CAR_URL: string = 'http://192.168.88.201'; //这里小车ip


const httpRequest = http.createHttp();

export class RequestUtil {
  static async get(url: string, isCar: boolean = false) {
    const requestPath = (isCar ? CAR_URL : BASE_URL) + url;
    let token = await StorageUtils.get("token", "")
    var header = {
      'Content-Type': 'application/json',
      'Authorization': token
    }
    let responseResult = await httpRequest.request(requestPath, {
      method: http.RequestMethod.GET,
      header: header
    });
    if (JSON.parse(responseResult.result as string)["code"] == 200) {
      return JSON.parse(responseResult.result as string)
    } else {
      if (JSON.parse(responseResult.result as string)["code"] == 401) {
        router.clear()
        router.replaceUrl({
          url: "pages/login/LoginPage",
        })
        return Promise.reject("登录信息过期，请重新登录")
      }
      return Promise.reject(JSON.parse(responseResult.result as string)["msg"])
    }
  }

  static async post(url: string, data: any) {
    const requestPath = BASE_URL + url;
    let token = await StorageUtils.get("token", "")
    var header = {
      'Content-Type': 'application/json',
      'Authorization': url == "/app/login" ? "" : token
    }

    let responseResult = await httpRequest.request(requestPath, {
      method: http.RequestMethod.POST,
      header: header,
      extraData: data
    });
    if (JSON.parse(responseResult.result as string)["code"] == 200) {
      return JSON.parse(responseResult.result as string)
    } else {
      if (JSON.parse(responseResult.result as string)["code"] == 401) {
        router.clear()
        router.replaceUrl({
          url: "pages/login/LoginPage"
        })
        return Promise.reject("登录信息过期，请重新登录")
      }
      return Promise.reject(JSON.parse(responseResult.result as string)["msg"])
    }
  }

  static async put(url: string, data: any) {
    const requestPath = BASE_URL + url;
    let token = await StorageUtils.get("token", "")
    var header = {
      'Content-Type': 'application/json',
      'Authorization': token
    }

    let responseResult = await httpRequest.request(requestPath, {
      method: http.RequestMethod.PUT,
      header: header,
      extraData: data
    });
    if (JSON.parse(responseResult.result as string)["code"] == 200) {
      return JSON.parse(responseResult.result as string)
    } else {
      if (JSON.parse(responseResult.result as string)["code"] == 401) {
        router.clear()
        router.replaceUrl({
          url: "pages/login/LoginPage"
        })
        return Promise.reject("登录信息过期，请重新登录")
      }
      return Promise.reject(JSON.parse(responseResult.result as string)["msg"])
    }
  }
}