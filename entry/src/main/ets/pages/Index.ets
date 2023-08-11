import http from '@ohos.net.http';
import util from '@ohos.util';
import CryptoJS from '@ohos/crypto-js'
import { YoudaoTranslateResult } from '../model/TranslateResult';

@Entry
@Component
struct Index {
  @State translateResult: string = '待翻译'
  @State sourceVoice: string = ''
  @State resultVoice: string = ''
  @State inputContent: string = '好好学习天天向上';
  @State from: string = 'zh'
  @State to: string = 'en'

  getInputForYoudaoSign() {
    var len = this.inputContent.length;
    if (len <= 20) {
      return this.inputContent;
    }
    return this.inputContent.substring(0, 10) + len + this.inputContent.substring(len - 10, len);
  }

  getShowLanguageName(code:string){
    if(code == 'zh'){
      return '中文';
    }else if(code == 'en'){
      return '英文'
    }else{
      return '自动识别'
    }
  }
  getTranslateCodeForYoudao(code:string){
    if(code =='en'){
      return 'en'
    }else if(code =='zh'){
      return 'zh-CHS'
    }
  }


  stringToUint8Array(str) {
    var arr = [];
    for (var i = 0, j = str.length; i < j; ++i) {
      arr.push(str.charCodeAt(i));
    }
    var tmpUint8Array = new Uint8Array(arr);
    return tmpUint8Array;
  }

  build() {
    Column() {
      TextInput({ placeholder: $r('app.string.text_to_be_translated') })
        .width('90%')
        .margin(10)
        .padding(10)
        .backgroundColor(Color.Gray)
        .borderRadius(10)
        .fontColor(Color.White)
        .onChange((value) => {
          this.inputContent = value
        })

      Row() {
        Text( this.getShowLanguageName(this.from)).margin(10)
        Image($r("app.media.switch_language_positions")).width(23).height(20).onClick(() => {

          var temp = this.from;
          this.from = this.to;
          this.to = temp

        })
        Text(this.getShowLanguageName(this.to)).margin(10)
      }.justifyContent(FlexAlign.SpaceAround).width('80%')

      Row() {


        Text('有道翻译')
          .fontColor(Color.White)
          .fontSize(18)
          .margin(10)
          .padding(10)
          .backgroundColor(Color.Green)
          .onClick(() => {

            var youdaoAppID = ''
            var youdaoSecretKey = '';

            let httpRequest = http.createHttp();
            let salt = util.generateRandomUUID(false);
            let currentTime = Math.round(new Date().getTime() / 1000)
            let signStr = youdaoAppID + this.getInputForYoudaoSign() + salt + currentTime + youdaoSecretKey;
            console.error('xuan', '加密字符串  ' + signStr)

            var sha256Result = CryptoJS.SHA256(signStr)

            console.error('sha256=' + sha256Result)
            var q = encodeURIComponent(this.inputContent)

            var params = `q=${q}&from=${this.getTranslateCodeForYoudao(this.from)}&to=${this.getTranslateCodeForYoudao(this.to)}&appKey=${youdaoAppID}&salt=${salt}&sign=${sha256Result.toString()}&signType=v3&curtime=${currentTime}`


            httpRequest.request(
              // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
              "https://openapi.youdao.com/api?" + params,
              {
                method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
                // 开发者根据自身业务需要添加header字段
                header: {
                  'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
                },
                // extraData: extraDate,
                expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
                usingCache: false, // 可选，默认为true
                priority: 1, // 可选，默认为1
                connectTimeout: 60000, // 可选，默认为60000ms
                readTimeout: 60000, // 可选，默认为60000ms
                usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
              }, (err, data) => {
              if (!err) {
                if (data.responseCode == http.ResponseCode.OK) {
                  const result: YoudaoTranslateResult = JSON.parse(data.result.toString());
                  var errorCode = result.errorCode
                  if (errorCode == '0') {
                    this.translateResult = result.translation.toString()
                    this.resultVoice = result.tSpeakUrl
                    this.sourceVoice = result.speakUrl
                  } else {
                    this.translateResult = JSON.stringify(result)
                    this.resultVoice = ''
                    this.sourceVoice = ''
                  }
                } else {
                  this.translateResult = '出错啦'
                  this.sourceVoice = ''
                  this.resultVoice = ''
                }

              } else {
                this.translateResult = JSON.stringify(err)
                this.resultVoice = ''
                this.sourceVoice = ''
                httpRequest.destroy();
              }
            }
            );


          })

        Text('百度翻译')
          .fontColor(Color.White)
          .fontSize(18)
          .margin(10)
          .padding(10)
          .backgroundColor(Color.Green)
          .onClick(() => {
            let httpRequest = http.createHttp();
            let salt = new Date().getTime();
            let baiduAppID = '';
            let baiduSec = '';
            let signStr = baiduAppID + this.inputContent + salt + baiduSec;
            console.error('xuan', '加密字符串  ' + signStr)

            var sha256Result = CryptoJS.MD5(signStr).toString()

            var params = `q=${this.inputContent}&from=${this.from}&to=${this.to}&appid=${baiduAppID}&salt=${salt}&sign=${sha256Result}`

            httpRequest.request(
              // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
              "https://fanyi-api.baidu.com/api/trans/vip/translate?" + params,
              {
                method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
                expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
                usingCache: false, // 可选，默认为true
                priority: 1, // 可选，默认为1
                connectTimeout: 60000, // 可选，默认为60000ms
                readTimeout: 60000, // 可选，默认为60000ms
                usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
              }, (err, data) => {


              if (!err) {
                this.translateResult = JSON.stringify(data.result);
                // data.result为HTTP响应内容，可根据业务需要进行解析
                console.error('Result:' + JSON.stringify(data.result));
                console.info('code:' + JSON.stringify(data.responseCode));
                // data.header为HTTP响应头，可根据业务需要进行解析
                console.info('header:' + JSON.stringify(data.header));
                console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
              } else {
                this.translateResult = JSON.stringify(err);
                console.error('error:' + JSON.stringify(err));
                // 取消订阅HTTP响应头事件
                httpRequest.off('headersReceive');
                // 当该请求使用完毕时，调用destroy方法主动销毁
                httpRequest.destroy();
              }
            }
            );
          })
      }.width('100%')

      Text(this.translateResult).margin(10).padding(10)
      Text(this.sourceVoice).margin(10).padding(10)
      Text(this.resultVoice).margin(10).padding(10)

    }
    .width('100%')

  }
}

