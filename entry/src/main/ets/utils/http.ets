import http from '@ohos.net.http';
const httpRequest = http.createHttp();
import storage from './storage'
import { base_url } from './env'

async function create_http(api: string, extraData: any, method: http.RequestMethod) {
  const tokens = await storage.get("token")
  // 测试使用 5天生效期
  let token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJiNzcxZjQxOC01MmQxLTRiMDQtOGI1NC0zNDBhMjE5MDdjZTQiLCJwYXNzd29yZCI6ImI0NWNmZmUwODRkZDNkMjBkOTI4YmVlODVlN2IwZjIxIiwiaWF0IjoxNzA1ODMyNDQzLCJleHAiOjE3MDk0Mjg4NDN9.KVWhUOCdxXT3kxH6dYSbQlRwCYpdBd9N_Jn1YObgqKM'
  return httpRequest.request(base_url + api, {
    method,
    connectTimeout: 20000,
    readTimeout: 20000,
    header: {
      'Content-Type': 'application/json',
      "Authorization": token ? 'Bearer ' + token : ''
    },
    extraData,
    expectDataType: http.HttpDataType.OBJECT
  });
}

export default {
  get: (api) => {
    return new Promise((resolve, reject) => {
      create_http(api, "", http.RequestMethod.GET).then((response) => {
        let result = response.result
        resolve(result)
      }).catch((error) => {
        reject(error)
      })
    })
  },
  post: (api, params = {}) => {
    return new Promise((resolve, reject) => {
      create_http(api, params, http.RequestMethod.POST).then((response) => {
        let result = response.result
        // 延迟 出现 loading 动画，交互使用
        setTimeout(()=>{
          resolve(result)
        },2000)
      }).catch((error) => {
        reject(error)
      })
    })
  }
}


