import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import SelectTranslateApiDialog from '../dialog/SelectTranslateApiDialog'
import SetTranslatorInfoDialog from '../dialog/SetTranslatorInfoDialog'
import { TranslationAPI } from '../model/TranslationAPI'
import {
  baidu_text_translation_api_key,
  baidu_text_translation_secret,
  baidu_ai_translation_general_key,
  baidu_ai_translation_general_secret,
  baidu_ai_translation_dict_key,
  baidu_ai_translation_dict_secret,
  youdao_ai_translation_general_key,
  youdao_ai_translation_general_secret,
} from '../model/GeneralConfig'
@Entry
@Component
struct SettingPage {
  selectTranslateApiDialogController: CustomDialogController = new CustomDialogController({
    builder: SelectTranslateApiDialog({
      confirm: (apiType: string) => {
        this.onSelectApi(apiType)
      }
    }),
    autoCancel: false,
    customStyle: true,

  })
  setTranslatorInfoDialogController: CustomDialogController = new CustomDialogController({
    builder: SetTranslatorInfoDialog(),
    autoCancel: false,
    customStyle: true,

  })

  aboutToAppear() {

  }

  aboutToDisappear() {

  }

  private onSelectApi(apiType: string):void {

    let needShowSetInfoDialog :boolean = false
    if (apiType == TranslationAPI.BAIDU_GENERAL) {
      let key:string = AppStorage.Get(baidu_text_translation_api_key)
      let secret:string = AppStorage.Get(baidu_text_translation_secret)
      if(key && key.length >0 && secret && secret.length >0){
        promptAction.showToast({message:"百度通用文本翻译已经设置"})
      }else{
        needShowSetInfoDialog = true
      }
    } else if (apiType == TranslationAPI.BAIDU_AI_GENERAL) {
      let key:string = AppStorage.Get(baidu_ai_translation_general_key)
      let secret:string = AppStorage.Get(baidu_ai_translation_general_secret)
      if(key && key.length >0 && secret && secret.length >0){
        promptAction.showToast({message:"百度机器翻译-文本翻译-通用版已经设置"})
      }else{
        needShowSetInfoDialog = true
      }
    } else if (apiType == TranslationAPI.BAIDU_AI_DICT) {
      let key:string = AppStorage.Get(baidu_ai_translation_dict_key)
      let secret:string = AppStorage.Get(baidu_ai_translation_dict_secret)
      if(key && key.length >0 && secret && secret.length >0){
        promptAction.showToast({message:"百度机器翻译-文本翻译-词典版已经设置"})
      }else{
        needShowSetInfoDialog = true
      }
    }else if(apiType == TranslationAPI.YOUDAO_GENERAL){
      let key:string = AppStorage.Get(youdao_ai_translation_general_key)
      let secret:string = AppStorage.Get(youdao_ai_translation_general_secret)
      if(key && key.length >0 && secret && secret.length >0){
        promptAction.showToast({message:"有道智云翻译已经设置"})
      }else{
        needShowSetInfoDialog = true
      }
    }
    if(needShowSetInfoDialog){
      this.setTranslatorInfoDialogController.open()
    }


  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.left_arrow')).width(24).height(24).onClick(() => {
          router.back()
        }).margin(15)
        Text("设置").textAlign(TextAlign.Center).fontSize(24).layoutWeight(1)
      }.alignItems(VerticalAlign.Center)

      Row() {
        Text("选择翻译接口").textAlign(TextAlign.Center).fontColor(Color.Black)
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        this.selectTranslateApiDialogController.open()

      })


      Row() {
        Text("百度通用文本翻译").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({ left: 15 }).onClick(() => {
          router.pushUrl({ url: 'pages/ApplyTranslateKey', params: { url: 'https://fanyi-api.baidu.com/product/11' } })
        })
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        this.setTranslatorInfoDialogController.open()
      }
      )

      Row() {
        Text("百度机器翻译：文本翻译-通用版").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({ left: 15 }).onClick(() => {
          router.pushUrl({
            url: 'pages/ApplyTranslateKey',
            params: { url: 'https://ai.baidu.com/ai-doc/MT/4kqryjku9' }
          })
        })
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        this.setTranslatorInfoDialogController.open()
      })

      Row() {
        Text("百度机器翻译：文本翻译-词典版").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({ left: 15 }).onClick(() => {
          router.pushUrl({
            url: 'pages/ApplyTranslateKey',
            params: { url: 'https://ai.baidu.com/ai-doc/MT/nkqrzmbpc' }
          })
        })
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        this.setTranslatorInfoDialogController.open()
      })

      Row() {
        Text("有道智云：文本翻译").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({ left: 15 })
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        promptAction.showToast({ message: "开发中~~" })
      })
    }.padding({ top: 48 })
  }
}
