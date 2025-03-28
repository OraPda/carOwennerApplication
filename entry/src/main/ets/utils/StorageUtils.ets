import dataPreferences from '@ohos.data.preferences'
/**
 * 项目全局存储，使用ohos.data.preferences
 */
const defaultPreferenceName = "MY_APP_PREFERENCES"

type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean>;


export class StorageUtils {

  static readonly context = getContext();

  /**
   * 获取Prefer实例
   * @param preferenceName
   * @returns
   */
  static async getPreferences(preferenceName: string = defaultPreferenceName) {
    return await dataPreferences.getPreferences(this.context, preferenceName)
  }

  static async put(key: string, value: ValueType, preferenceName: string = defaultPreferenceName) {
    // 获取实例
    let preferences = await this.getPreferences(preferenceName)
    preferences.put(key, value)
    preferences.flush()
  }
  /**
   * 获取值
   * @param key
   * @param defaultValue
   * @param preferenceName
   * @returns
   */
  static async get(key: string, defaultValue: ValueType = "", preferenceName: string = defaultPreferenceName) {
    // 获取实例
    let preferences = await this.getPreferences(preferenceName)
    return preferences.get(key, defaultValue)
  }

  /**
   * 删除值
   * @param key
   * @param preferenceName
   * @returns
   */
  static async delete(key: string, preferenceName: string = defaultPreferenceName) {
    let preferences = await this.getPreferences(preferenceName)
    return await preferences.delete(key)
    preferences.flush()
  }

  /**
   * 清空
   * @param preferenceName
   * @returns
   */
  static async clear(preferenceName: string = defaultPreferenceName) {
    let preferences = await this.getPreferences(preferenceName)
    return await preferences.clear()
    preferences.flush()
  }
  /*
  清空内容
   */
  static async clearInfo() {
    await StorageUtils.put("isLogin",false)
    await StorageUtils.put("token","")
    await StorageUtils.put("carId","")
    await StorageUtils.put("userName","")
    await StorageUtils.put("carVin","")
  }
}