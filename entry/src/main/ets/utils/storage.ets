import common from '@ohos.app.ability.common';
import data_preferences from '@ohos.data.preferences';
const context = getContext(this) as common.UIAbilityContext;
let promise = data_preferences.getPreferences(context, 'stroage')

export default {
  set: (key: string, value: string): Promise<string> => {
    return new Promise((resolve, reject) => {
      promise.then((preferences) => {
        preferences.put(key, value).then(res => {
          console.info("缓存成功");
          resolve("")
        }).catch((err) => {
          console.error("缓存失败：",JSON.stringify(err));
          reject(JSON.stringify(err))
        })
      }).catch((err) => {
        console.error("缓存初始化失败：",JSON.stringify(err));
        reject(JSON.stringify(err))
      })
    })
  },
  get: (key: string): Promise<string> => {
    return new Promise((resolve, reject) => {
      promise.then((preferences) => {
        preferences.get(key,'').then((res:string) => {
          resolve(res)
        }).catch((err) => {
          console.error("获取失败：",JSON.stringify(err));
          reject(JSON.stringify(err))
        })
      }).catch((err) => {
        console.error("获取缓存异常：",JSON.stringify(err));
        reject(JSON.stringify(err))
      })
    })
  },
  clear: (): Promise<boolean> => {
    return new Promise((resolve, reject) => {
      promise.then((preferences) => {
        preferences.clear().then(() => {
          resolve(true)
        }).catch((err) => {
          reject(JSON.stringify(err))
        })
      }).catch((err) => {
        reject(JSON.stringify(err))
      })
    })
  }
}