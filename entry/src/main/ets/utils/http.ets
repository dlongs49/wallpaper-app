import http from '@ohos.net.http';
let httpRequest = http.createHttp();
const base_url = "http://192.168.2.102"
function create_http(api:string,extraData:any,method:http.RequestMethod){
  return httpRequest.request(base_url+api, {
    method,
    connectTimeout: 20000,
    readTimeout: 20000,
    header: {
      'Content-Type': 'application/json'
    },
    extraData,
    expectDataType:http.HttpDataType.OBJECT
  });
}

export default {
  get:(api,)=>{
    return new Promise((resolve,reject) =>{
      create_http(api,"",http.RequestMethod.GET).then((response)=>{
        console.log("",response)
      }).catch((error)=>{
        reject(error)
      })
    })
  },
  post:(api,params = {})=>{
    return new Promise((resolve,reject) =>{
      create_http(api,params,http.RequestMethod.POST).then((response)=>{
        let result = response.result
        resolve(result)
      }).catch((error)=>{
        reject(error)
      })
    })
  }
}

