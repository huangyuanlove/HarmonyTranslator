import router from '@ohos.router';

import {
  baidu_text_translation_api_key,
  baidu_text_translation_secret,
  baidu_ai_translation_general_key,
  baidu_ai_translation_general_secret,
  translation_api
} from '../model/GeneralConfig'
import { TranslationAPI } from '../model/TranslationAPI';

@CustomDialog
export default struct SetTranslatorInfoDialog {
  controller: CustomDialogController;
  @State appID: string = ''
  @State secret: string = ''

  @StorageLink(translation_api) translationApiType: string = TranslationAPI.BAIDU_GENERAL

  private getRegisterUrl(): string {
    if (this.translationApiType == TranslationAPI.BAIDU_GENERAL) {
      return 'https://fanyi-api.baidu.com/doc/21'
    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_GENERAL) {
      return 'https://ai.baidu.com/ai-doc/MT/4kqryjku9'
    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_DICT) {
      return 'https://ai.baidu.com/ai-doc/MT/nkqrzmbpc'
    } else if(this.translationApiType == TranslationAPI.YOUDAO_GENERAL){
      return 'https://ai.youdao.com/doc.s#guide'
    }
    return ''
  }

  private getRegisterText():string{
    if (this.translationApiType == TranslationAPI.BAIDU_GENERAL) {
      return '如何申请：百度通用文本翻译API'
    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_GENERAL) {
      return '如何申请：百度机器翻译-文本翻译-通用版'
    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_DICT) {
      return '如何申请：百度机器翻译-文本翻译-词典版'
    }else if(this.translationApiType == TranslationAPI.YOUDAO_GENERAL){
      return '如何申请：有道智云翻译'
    }
  }


  private updateApiKeyAndSecret(): void {
    if (this.translationApiType == TranslationAPI.BAIDU_GENERAL) {
      AppStorage.SetOrCreate<string>(baidu_text_translation_api_key, this.appID)
      AppStorage.SetOrCreate<string>(baidu_text_translation_secret, this.secret)

    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_GENERAL || this.translationApiType == TranslationAPI.BAIDU_AI_DICT) {
      AppStorage.SetOrCreate<string>(baidu_ai_translation_general_key, this.appID)
      AppStorage.SetOrCreate<string>(baidu_ai_translation_general_secret, this.secret)
    }
  }

  build() {
    Column() {
      Row() {
        Text(this.getRegisterText())
        Image($r('app.media.tip')).width(20).height(20)
      }.justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center).onClick(() => {
        router.pushUrl({
          url: 'pages/ApplyTranslateKey',
          params: { 'url': this.getRegisterUrl() }
        })
      })


      TextInput({ placeholder: '请输入申请的API Key' }).onChange((value) => {
        this.appID = value.toString()
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

            this.updateApiKeyAndSecret()

            if (this.controller != undefined) {
              this.controller.close()
            }

          })
          .backgroundColor(0X39d157)
          .borderRadius(8)
          .fontColor(Color.White)
          .padding({ top: 10, bottom: 10, left: 15, right: 15 })
      }.justifyContent(FlexAlign.SpaceAround).width('80%')
    }.margin(15).borderRadius(10).backgroundColor(Color.White).padding(10)
  }
}
