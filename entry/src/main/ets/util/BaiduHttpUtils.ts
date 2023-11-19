import http from '@ohos.net.http';
import { TranslateLanguage, TranslationGroup } from '../model/TranslateResult';
import {CryptoJS} from '@ohos/crypto-js'
import { AccessTokenResult, OnGetAccessTokenCallback, OnTranslationCallback,OnTranslationCallBackTmp } from './CommonCallback';
import {baidu_text_translation_api_key,baidu_text_translation_secret,source_language,target_language} from '../model/GeneralConfig'
import promptAction from '@ohos.promptAction';

export class BaiduHttpUtil {

  /**
   * {"responseCode":200,"cookies":".baidu.com\tTRUE\t/\tFALSE\t1731230596\tBAIDUID\t2C29A634B051655D4A752434BC587136:FG=1","header":{"content-length":"54","content-type":"application/json","date":"Sat, 11 Nov 2023 09:23:17 GMT","p3p":"CP=\" OTI DSP COR IVA OUR IND COM \"","server":"Apache","set-cookie":"BAIDUID=2C29A634B051655D4A752434BC587136:FG=1; expires=Sun, 10-Nov-24 09:23:17 GMT; max-age=31536000; path=/; domain=.baidu.com; version=1","tracecode":"13970427782338333450111117"},"result":"{\"error_code\":\"52003\",\"error_msg\":\"UNAUTHORIZED USER\"}","resultType":0}
   * @param query
   * @param callBack
   */
  static translateByTextGeneral(query:string,callBack:OnTranslationCallBackTmp){

    var api_key :string =  AppStorage.Get(baidu_text_translation_api_key)
    var secret :string =AppStorage.Get(baidu_text_translation_secret)

    var from:string = AppStorage.Get<TranslateLanguage>(source_language).code
    var to:string = AppStorage.Get<TranslateLanguage>(target_language).code

    if(!api_key || !secret){
      console.error("请先设置百度通用文本翻译appid 和 secret")
      promptAction.showToast({message:"请先设置百度通用文本翻译appid 和 secret"})
      return
    }
    if(from == to){
      console.error("源语言和目标语言相同")
      promptAction.showToast({message:"源语言和目标语言相同"})
      return ;
    }


    if(!query || query.length == 0){
      return
    }

    var salt = new Date().getTime()
    var raw = `${api_key}${query}${salt}${secret}`
    console.error(`通用文本翻譯 raw ${raw}`)
    var md5Result  = CryptoJS.MD5(raw)
    console.error(`通用文本翻譯 md5 ${md5Result}`)

    var url :string = `https://fanyi-api.baidu.com/api/trans/vip/translate?q=${encodeURI(query)}&from=${from}&to=${to}&appid=${api_key}&salt=${salt}&sign=${md5Result}`
    console.error("请求地址-->" + url)
    let httpRequest = http.createHttp()
    httpRequest.request(url,
      {
        method:http.RequestMethod.GET,
        header:{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },

        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
        usingCache: false, // 可选，默认为true
        priority: 1, // 可选，默认为1
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
      },(error,data)=>{
        if(error){
          console.error('百度通用文本翻译出错')
          console.error(JSON.stringify(error))
          callBack(JSON.stringify(error))
        }else{
          console.error('百度通用文本翻译完成')
          console.error(JSON.stringify(data))
          callBack(data.result.toString())
        }
      }
    )

  }


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