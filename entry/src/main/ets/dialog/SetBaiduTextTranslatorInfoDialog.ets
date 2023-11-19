

import router from '@ohos.router';

import {baidu_text_translation_api_key,baidu_text_translation_secret} from '../model/GeneralConfig'

@CustomDialog
export default struct SetBaiduTextTranslatorInfoDialog {
  controller: CustomDialogController;
  @State appid: string = ''
  @State secret: string = ''

  @StorageLink(baidu_text_translation_api_key)  apiKey :string ='';
  @StorageLink(baidu_text_translation_secret) appSecret:string =''




  build() {
    Column() {

      Row() {
        Text('如何申请：百度翻译-')
        Image($r('app.media.tip')).width(20).height(20)
      }.justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center).onClick(() => {
        router.pushUrl({
          url: 'pages/ApplyTranslateKey',
          params: { 'url': 'https://fanyi-api.baidu.com/doc/21' }
        })
      })


      TextInput({ placeholder: '请输入申请的API Key' }).onChange((value) => {
        this.appid = value.toString()
      }).margin(10).padding(10).borderRadius(10)
      TextInput({ placeholder: '请输入申请的Secret Key' })
        .onChange((value) => {
          this.secret = value.toString()
        }).margin(10).padding(10).borderRadius(10)
      Row() {
        Text('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
            }
          })
          .backgroundColor(Color.Gray)
          .borderRadius(8)
          .fontColor(Color.White)
          .padding({ top: 10, bottom: 10, left: 15, right: 15 })
        Text('确认')
          .onClick(() => {

            this.apiKey = this.appid
            this.appSecret = this.secret

            if (this.controller != undefined) {
              this.controller.close()
            }
            console.error("AppStorage appid "+AppStorage.Get<string>(baidu_text_translation_api_key))
            console.error("AppStorage secret "+AppStorage.Get<string>(baidu_text_translation_secret))


          })
          .backgroundColor(0X39d157)
          .borderRadius(8)
          .fontColor(Color.White)
          .padding({ top: 10, bottom: 10, left: 15, right: 15 })
      }.justifyContent(FlexAlign.SpaceAround).width('80%')
    }.margin(15).borderRadius(10).backgroundColor(Color.White).padding(10)
  }
}
