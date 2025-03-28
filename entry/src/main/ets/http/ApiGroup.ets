import { BASE_URL, RequestUtil } from "../http/RequestUtil"
import { StorageUtils } from '../utils/StorageUtils';

//登录接口
export function login(data): Promise<object> {
  return RequestUtil.post("/app/login", data)
}

//注册接口
export function register(data): Promise<object> {
  return RequestUtil.post("/system/user/register", data)
}

//上传图片
export const uploadUrl: string = BASE_URL + "/common/uploadFeedback";

//提交反馈
export function addFeedback(data): Promise<object> {
  return RequestUtil.post("/cockpit/feedback/add", data)
}

//获取反馈列表
export function getFbList(): Promise<object> {
  return RequestUtil.get("/cockpit/feedback/backList")
}

//修改意见反馈已读状态
export function changeFbStatus(data): Promise<object> {
  return RequestUtil.post("/cockpit/feedback/editReplyRead", data)
}

//查询上传文件地址 fileName
export function getImagePath(data): Promise<object> {
  return RequestUtil.post("/cockpit/path/picUrl", data)
}

//查询用户信息
export function getUserInfo(): Promise<object> {
  return RequestUtil.get("/getInfo")
}

//查询用户信息
export async function getUserInfoById(): Promise<object> {
  let userId = await StorageUtils.get("userId", "")
  return RequestUtil.get("/system/user/" + userId)
}

//修改用户信息
export function updateUser(data): Promise<object> {
  return RequestUtil.put("/system/user", data)
}

//通过车架号绑定车辆
export function bindCar(data): Promise<object> {
  return RequestUtil.post("/cockpit/info/bindCarVin", data)
}

//获取车辆状态信息
export async function getCarState(): Promise<object> {
  let carVin = await StorageUtils.get("carVin", "")
  return RequestUtil.get("/cockpit/state/" + carVin)
}

//修改车辆状态
export async function changeCarState(data): Promise<object> {
  let carVin = await StorageUtils.get("carVin", "")
  data["carVin"] = carVin;
  return RequestUtil.put("/cockpit/state", data)
}

//获取车辆信息详情
export async function getCarInfo(): Promise<object> {
  let carId = await StorageUtils.get("carId", "")
  console.log("carId" + carId)
  return RequestUtil.get("/cockpit/info/" + carId)
}

//查询车辆操控日志列表
export async function getLogList(pageNum: number): Promise<object> {
  let userId = await StorageUtils.get("userId")
  console.log("userId" + userId)
  return RequestUtil.get(`/cockpit/log/list?userId=${userId}&pageNum=${pageNum}&pageSize=10&operaContent=`)
}

// 读取NFC
export function readNFC(data): Promise<object> {
  return RequestUtil.post("/cockpit/control/nfc/" + data, {})
}

// 前
export async function move(data): Promise<object> {
  let carId = await StorageUtils.get("carId", "")
  return RequestUtil.post("/cockpit/control/move/" + carId, {})
}

// 后
export async function back(data): Promise<object> {
  let carId = await StorageUtils.get("carId", "")
  return RequestUtil.post("/cockpit/control/back/" + carId, {})
}

// 左
export async function left(data): Promise<object> {
  let carId = await StorageUtils.get("carId", "")
  return RequestUtil.post("/cockpit/control/left/" + carId, {})
}

// 右
export async function right(data): Promise<object> {
  let carId = await StorageUtils.get("carId", "")
  return RequestUtil.post("/cockpit/control/right/" + carId, {})
}

// 停
export async function stop(data): Promise<object> {
  let carId = await StorageUtils.get("carId", "")
  return RequestUtil.post("/cockpit/control/stop/" + carId, {})
}

// 修改车灯
export async function updateLight(data) {
  return RequestUtil.post("/cockpit/control/light", data)
}

// 修改车门
export async function updateDoor(data) {
  return RequestUtil.post("/cockpit/control/door", data)
}

// 数据统计
export async function statistics() {
  return RequestUtil.get("/train/mileage/stat")
}

// ledoff
export async function ledOff() {
  return RequestUtil.get("/ledoff?" + new Date().getTime().toString(),true)
}

// ledon
export async function ledOn() {
  return RequestUtil.get("/ledon?" + new Date().getTime().toString(),true)
}

// go
export async function carGo() {
  return RequestUtil.get("/go?" + new Date().getTime().toString(),true)
}

// back
export async function carBack() {
  return RequestUtil.get("/back?" + new Date().getTime().toString(),true)
}

//left
export async function carLeft() {
  return RequestUtil.get("/left?" + new Date().getTime().toString(),true)
}

//right
export async function carRight() {
  return RequestUtil.get("/right?" + new Date().getTime().toString(),true)
}
//stop
export async function carStop() {
  return RequestUtil.get("/stop?" + new Date().getTime().toString(),true)
}

