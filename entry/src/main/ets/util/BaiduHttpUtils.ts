import http from '@ohos.net.http';
import { TranslationGroup } from '../model/TranslateResult';
import { AccessTokenResult, OnGetAccessTokenCallback, OnTranslationCallback } from './CommonCallback';
export class BaiduHttpUtil {
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

  static translateByMachineGeneral(from: string, to: string, query: string, token: string, callback: OnTranslationCallback) {

    console.error(`from=${from}  to=${to}  q=${query}  token=${token}`)

    let httpRequest = http.createHttp();
    httpRequest.request('https://aip.baidubce.com/rpc/2.0/mt/texttrans/v1?access_token=' + token, {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json;charset=utf-8' },
      extraData: {
        from: from,
        to: to,
        q: query
      },
      expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      usingCache: false, // 可选，默认为true
      priority: 1, // 可选，默认为1
      connectTimeout: 60000, // 可选，默认为60000ms
      readTimeout: 60000, // 可选，默认为60000ms
      usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
    },
      (err, data) => {

        var tmp: TranslationGroup = new TranslationGroup();
        tmp.apiName = '百度机器翻译词典版'
        tmp.log_id = rootJson['log_id']


        if (err) {
          tmp.error = JSON.stringify(err).toString();
          callback(tmp)
        } else {

          var rootJson = JSON.parse(data.result.toString());

          var errorCode = rootJson['error_code']
          var errorMsg = rootJson['error_msg']
          if (errorCode != undefined) {
            tmp.error = `errorCode:${errorCode} ,errorMsg:${errorMsg}`
            callback(tmp)
            return
          }

          var resultJSON = rootJson['result']

          var trans_result_arr: JSON [] = resultJSON['trans_result']
          if (trans_result_arr && trans_result_arr.length > 0) {
            tmp.dst = [];
            trans_result_arr.forEach(trans_result => {
              tmp.dst.push(trans_result['dst']);
            })
          }
          callback(tmp)
        }

      }

    )
  }
}