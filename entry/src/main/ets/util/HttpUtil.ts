import http from '@ohos.net.http';
import { BaiduTranslationResult, Dict, TransResult } from '../model/TranslateResult'

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

  static translate(from: string, to: string, query: string, token: string, callback: OnTranslationCallback) {

    console.error(`from=${from}  to=${to}  q=${query}  token=${token}`)

    let httpRequest = http.createHttp();
    httpRequest.request('https://aip.baidubce.com/rpc/2.0/mt/texttrans-with-dict/v1?access_token=' + token, {
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
        if (err) {
          console.error(JSON.stringify(err).toString())
          callback(err, null)
        } else {

          var rootJson = JSON.parse(data.result.toString());

          var errorCode = rootJson['error_code']
          var errorMsg = rootJson['error_msg']
          if(errorCode !=undefined){
            callback(`errorCode:${errorCode} ,errorMsg:${errorMsg}`,null)
            return
          }
          var tmp: BaiduTranslationResult = new BaiduTranslationResult();
          tmp.log_id = rootJson['log_id']
          var resultJSON = rootJson['result']
          tmp.from = resultJSON['from']
          tmp.to = resultJSON['to']
          var trans_result_arr: JSON [] = resultJSON['trans_result']
          if (trans_result_arr && trans_result_arr.length > 0) {
            var trans_result = trans_result_arr[0]
            var transResult: TransResult = new TransResult();
            transResult.dst = trans_result['dst']
            transResult.dst_tts = trans_result['dst_tts']
            transResult.src = trans_result['src']
            transResult.src_tts = trans_result['src_tts']
            var dictJSON:JSON = JSON.parse(trans_result['dict'])

            if (dictJSON) {

              var wordResultJSON:JSON = dictJSON['word_result']
              if (wordResultJSON) {
                var simpleMeansJSON:JSON = wordResultJSON['simple_means']
                if (simpleMeansJSON) {
                  transResult.result = simpleMeansJSON['word_means']
                }
              }

            }
            var dict: Dict = new Dict();
            transResult.dict = dict
            tmp.result = transResult;

          }
          callback(err, tmp)
        }

      }

    )
  }
}


export interface OnGetAccessTokenCallback {

  (error: Object, data: AccessTokenResult): void;
}

export interface OnTranslationCallback {
  (error: Object, data: BaiduTranslationResult)
}

export class AccessTokenResult {
  access_token: string
  expires_in: number
}