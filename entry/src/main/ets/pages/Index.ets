import http from '@ohos.net.http';
import util from '@ohos.util';
import CryptoJS from '@ohos/crypto-js'
import prompt from '@ohos.promptAction';
import { YoudaoTranslateResult, TranslateLanguage, LanguageGroup } from '../model/TranslateResult';

//只能在UI页面使用，否则无法持久化数据
PersistentStorage.PersistProp('translate_from_name', '自动识别')
PersistentStorage.PersistProp('translate_from_code', 'auto')
PersistentStorage.PersistProp('translate_to_name', '英文')
PersistentStorage.PersistProp('translate_to_code', 'en')
PersistentStorage.PersistProp('youdao_app_id', '')
PersistentStorage.PersistProp('youdao_secrite', '')


@Entry
@Component
struct Index {
  @State translateResult: string = '待翻译'
  @State sourceVoice: string = ''
  @State resultVoice: string = ''
  @State inputContent: string = '好好学习天天向上';
  @State textValue: string = ''
  @State inputValue: string = 'click me'
  @StorageLink('translate_from_name') translateFromName: string = 'aaaaa'
  @StorageLink('translate_from_code') translateFromCode: string = 'auto'
  @StorageLink('translate_to_name') translateToName: string = '英文'
  @StorageLink('translate_to_code') translateToCode: string = 'en'
  @StorageLink('youdao_app_id') youdao_app_id: string = ''
  @StorageLink('youdao_secrite') youdao_secrite: string = ''
  @State changeFromLanguageType: boolean = false;
  @State changeToLanguageType: boolean = false;

  aboutToAppear() {

  }

  aboutToDisappear() {
    delete this.dialogController, // 删除dialogController
    this.dialogController = undefined // 将dialogController置空
    delete this.setAppInfoDialogController, // 删除dialogController
    this.setAppInfoDialogController = undefined // 将dialogController置空
  }

  onAccept(selectLanguage: TranslateLanguage) {
    console.error('this is ?' + this)
    this.translateFromName = selectLanguage.name
    this.translateFromCode = selectLanguage.code
    console.error('Callback when the second button is clicked')
    prompt.showToast({ message: "选择的语言--> " + selectLanguage.name + ",code-->" + selectLanguage.code })

  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: SelectLanguageDialog({
      confirm: this.onAccept.bind(this),
    }),
    autoCancel: true,
  })

  setAppInfoDialogController : CustomDialogController = new CustomDialogController({
    builder:SetApiInfoDialog(),
    customStyle:true

  })


  getInputForYoudaoSign() {
    var len = this.inputContent.length;
    if (len <= 20) {
      return this.inputContent;
    }
    return this.inputContent.substring(0, 10) + len + this.inputContent.substring(len - 10, len);
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
      .onEditChange((isEdit)=>{
        console.error('isEdit-->' + isEdit)
      })
      Stack({alignContent:Alignment.End}) {


        Row() {
          Text(this.translateFromName).margin(10).width('40%')
            .onClick(() => {
              if (this.dialogController != undefined) {
                this.changeFromLanguageType = true;
                this.changeToLanguageType = false;
                this.dialogController.open()
              }
            }).textAlign(TextAlign.Center)


          Image($r("app.media.switch_language_positions")).width(23).height(20).onClick(() => {
            [this.translateToCode, this.translateFromCode] = [this.translateFromCode, this.translateToCode];
            [this.translateToName, this.translateFromName] = [this.translateFromName, this.translateToName];
          })
          Text(this.translateToName).margin(10).width('40%')
            .onClick(() => {
              this.changeFromLanguageType = true;
              this.changeToLanguageType = false;
              this.dialogController.open()
            }).textAlign(TextAlign.Center)
        }.justifyContent(FlexAlign.SpaceAround).width('100%')

        Image($r('app.media.setting')).width(18).height(18)
          .onClick(() => {
            prompt.showToast({ message: '配置appid 和 appkey' });
            if(this.setAppInfoDialogController != undefined){
              this.setAppInfoDialogController.open()
            }
          }).margin({right:15})
      }.width('100%')


      Row() {
        Text('有道翻译')
          .fontColor(Color.White)
          .fontSize(18)
          .margin(10)
          .padding(10)
          .backgroundColor(Color.Green)
          .onClick(() => {



            let httpRequest = http.createHttp();
            let salt = util.generateRandomUUID(false);
            let currentTime = Math.round(new Date().getTime() / 1000)
            let signStr = this.youdao_app_id + this.getInputForYoudaoSign() + salt + currentTime + this.youdao_secrite;
            console.error('xuan', '加密字符串  ' + signStr)

            var sha256Result = CryptoJS.SHA256(signStr)

            console.error('sha256=' + sha256Result)
            var q = encodeURIComponent(this.inputContent)

            var params = `q=${q}&from=${this.translateFromCode}&to=${this.translateToCode}&appKey=${this.youdao_app_id}&salt=${salt}&sign=${sha256Result.toString()}&signType=v3&curtime=${currentTime}`


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
      }.width('100%')

      Text(this.translateResult).margin(10).padding(10)
      Text(this.sourceVoice).margin(10).padding(10)
      Text(this.resultVoice).margin(10).padding(10)

    }
    .width('100%')

  }
}


@CustomDialog
struct SelectLanguageDialog {
  controller: CustomDialogController
  confirm: (selectLanguage: TranslateLanguage) => void

  build() {
    SelectLanguageList({ confirm: this.confirm, controller: this.controller })
  }
}


@Component
struct SelectLanguageList {
  confirm: (selectLanguage: TranslateLanguage) => void
  controller: CustomDialogController
  private data: LanguageGroup[] = [
    new LanguageGroup('常用', [new TranslateLanguage('中文', 'zh-CHS'), new TranslateLanguage('英文', 'en'),]),
    new LanguageGroup('全部', [new TranslateLanguage('中文', 'zh-CHS'), new TranslateLanguage('英文', 'en'), new TranslateLanguage('德语', 'de'), new TranslateLanguage('法语', 'fr'), new TranslateLanguage('日语', 'ja'), new TranslateLanguage('韩语', 'ko'),]),
  ]

  @Builder itemHead(text: string) {
    Text(text)
      .fontSize(20)
      .width("100%")
      .padding(10)
  }

  build() {
    List({ space: 20 }) {
      ForEach(this.data, (languageGroup: LanguageGroup) => {
        ListItemGroup({ header: this.itemHead(languageGroup.groupName) }) {
          ForEach(languageGroup.languages, (language: TranslateLanguage) => {
            ListItem() {
              Text(language.name)
                .width("80%")
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .borderRadius(10)
                .margin(10)
                .backgroundColor(0x39d167)
                .onClick(() => {
                  console.error('列表数据长度-->' + this.data.length + ' 分组长度-->' + languageGroup.languages.length);
                  if (this.confirm != undefined) {
                    this.confirm(language)
                  }
                  if (this.controller != undefined) {
                    this.controller.close()
                  }
                })
            }
          }, (language: TranslateLanguage) => {
            return language.code + languageGroup.groupName
          })
        }

      })
    }

    .width('90%')
    .sticky(StickyStyle.Header)
  }
}


@CustomDialog
struct SetApiInfoDialog{

  controller:CustomDialogController;

  @State appid:string = ''
  @State appKey:string =''

  @StorageLink('youdao_app_id') storageId:string = ''
  @StorageLink('youdao_secrite') storageKey:string = ''

  build(){
    Column(){
      TextInput({placeholder:'请输入申请的应用id'}).onChange((value)=>{
        this.appid = value.toString()
      }).margin(10).padding(10).borderRadius(10)
      TextInput({placeholder:'请输入申请的应用密钥'})
        .onChange((value)=>{
          this.appKey = value.toString()
        }).margin(10).padding(10).borderRadius(10)
      Row(){
        Text('取消').onClick(()=>{
          if(this.controller != undefined){
            this.controller.close()
          }
        }).backgroundColor(Color.Gray).borderRadius(8).fontColor(Color.White).padding({top:10,bottom:10,left:15,right:15})
        Text('确认').onClick(()=>{

          this.storageId = this.appid
          this.storageKey = this.appKey
          if(this.controller != undefined){
            this.controller.close()
          }
        }).backgroundColor(0X39d157).borderRadius(8).fontColor(Color.White).padding({top:10,bottom:10,left:15,right:15})
      }.justifyContent(FlexAlign.SpaceAround).width('80%')
    }.margin(15).borderRadius(10).backgroundColor(Color.White).padding(10)
  }
}
