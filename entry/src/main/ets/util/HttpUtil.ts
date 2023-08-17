import http from '@ohos.net.http';
import {BaiduTranslationResult} from '../model/TranslateResult'

export class HttpUtil {
  static getAccessToken(apiKey: string, secretKey: String, callback: OnGetAccessTokenCallback) {
    var url: string = `https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=${apiKey}&client_secret=${secretKey}`
    let httpRequest = http.createHttp();
    httpRequest.request(url,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
        usingCache: false, // 可选，默认为true
        priority: 1, // 可选，默认为1
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
      }, (err, data) => {
        if (err) {
          callback(err, null)
        } else {
          let result = JSON.parse(data.result.toString())

          let error = result['error']
          if (error) {
            callback(error, null)
          } else {
            let accessTokenResult: AccessTokenResult = new AccessTokenResult()
            accessTokenResult.access_token = result['access_token']
            accessTokenResult.expires_in = result['expires_in']
            callback(null, accessTokenResult)
          }

        }
      }
    )

  }

  static translate(from: string, to: string, query: string,token:string,callback:OnTranslationCallback) {

    console.error(`from=${from}  to=${to}  q=${query}  token=${token}`)

    let httpRequest = http.createHttp();
    httpRequest.request('https://aip.baidubce.com/rpc/2.0/mt/texttrans-with-dict/v1?access_token='+token, {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json;charset=utf-8' },
      extraData: {
        from:from,
        to:to,
        q:query
      },
      expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      usingCache: false, // 可选，默认为true
      priority: 1, // 可选，默认为1
      connectTimeout: 60000, // 可选，默认为60000ms
      readTimeout: 60000, // 可选，默认为60000ms
      usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
    },


      (err, data) => {
      if(err){
        console.error(JSON.stringify(err).toString())
        callback(err,null)
      }else{

        var result = JSON.parse(data.result.toString());
        var tmp :BaiduTranslationResult = new BaiduTranslationResult();
        tmp.log_id = result['log_id']
        var transResult = result['trans_result']
        console.error(result.toString())
        callback(err,tmp)
      }

    }

    )
  }
}


export interface OnGetAccessTokenCallback {

  (error: Object, data: AccessTokenResult): void;
}
export interface OnTranslationCallback{
  (error:Object,data:BaiduTranslationResult)
}

export class AccessTokenResult {
  access_token: string
  expires_in: number
}