import prompt from '@ohos.promptAction';


import { TranslationResult, TranslateLanguage, TranslationGroup } from '../model/TranslateResult'
import {
  baidu_machine_translation_general_api_key,
  baidu_machine_translation_general_secret_key
} from '../model/Config'
import { TranslationAPI } from '../model/TranslationAPI'

import { MainPageTopSwiper } from '../view/MainPageTopSwiper';
import { BaiduHttpUtil } from '../util/BaiduHttpUtils';
import { TranslationResultView } from '../view/TranslationResultView';
import SelectLanguageDialog from '../dialog/SelectLanguageDialog';
import SetApiInfoDialog from '../dialog/SetApiInfoDialog';
import SetUserPreferDialog from '../dialog/SetUserPreferDialog';
//只能在UI页面使用，否则无法持久化数据
PersistentStorage.PersistProp('translate_from', new TranslateLanguage('中文', 'zh'))
PersistentStorage.PersistProp('translate_to', new TranslateLanguage('英文', 'en'))
PersistentStorage.PersistProp('baidu_machine_translation_general_api_key', baidu_machine_translation_general_api_key)
PersistentStorage.PersistProp('baidu_machine_translation_general_secret_key', baidu_machine_translation_general_secret_key)
PersistentStorage.PersistProp('translate_type', 'immediately')
PersistentStorage.PersistProp('translate_api', TranslationAPI.BAIDU_GENERAL)


@Entry
@Component
struct Index {
  @State translation: TranslationResult = null;
  @State inputContent: string = '';
  @State baidu_access_token: string = '';
  @StorageLink('translate_api') translationApiType: TranslationAPI = TranslationAPI.BAIDU_GENERAL
  @StorageLink('translate_from_name') translateFrom: TranslateLanguage = new TranslateLanguage('中文', 'zh')
  @StorageLink('translate_to_name') translateTo: TranslateLanguage = new TranslateLanguage('英文', 'en')
  @StorageLink('baidu_machine_translation_general_api_key') baidu_api_key: string = ''
  @StorageLink('baidu_machine_translation_general_secret_key') baidu_secret_key: string = ''
  @StorageLink('translate_type') translate_type: string = 'immediately'
  @State changeFromLanguageType: boolean = false;
  @State changeToLanguageType: boolean = false;
  private queryTimer: number = 0;

  aboutToAppear() {
    this.translation = new TranslationResult()


    BaiduHttpUtil.getAccessToken(this.baidu_api_key, this.baidu_secret_key, (error, data) => {
      if (error) {
        console.error("获取 token 失败-->")
        prompt.showToast({ message: error.toString() })
      } else {
        console.error("获取 token 成功-->")
        this.baidu_access_token = data.access_token
      }
    })


  }

  aboutToDisappear() {
    delete this.selectLanguageDialogController, // 删除dialogController
    this.selectLanguageDialogController = undefined // 将dialogController置空
    delete this.setAppInfoDialogController, // 删除dialogController
    this.setAppInfoDialogController = undefined // 将dialogController置空
    delete this.setUserPreferDialogController, // 删除dialogController
    this.setUserPreferDialogController = undefined // 将dialogController置空
  }

  onAccept(selectLanguage: TranslateLanguage) {
    console.error('this is ?' + this)
    if (this.changeFromLanguageType) {
      this.translateFrom = selectLanguage

    } else if (this.changeToLanguageType) {
      this.translateTo = selectLanguage
    }

    console.error('Callback when the second button is clicked')
    prompt.showToast({ message: "选择的语言--> " + selectLanguage.name + ",code-->" + selectLanguage.code })

  }

  selectLanguageDialogController: CustomDialogController = new CustomDialogController({
    builder: SelectLanguageDialog({
      confirm: this.onAccept.bind(this),
    }),
    autoCancel: true,
  })
  setAppInfoDialogController: CustomDialogController = new CustomDialogController({
    builder: SetApiInfoDialog(),
    customStyle: true

  })
  setUserPreferDialogController: CustomDialogController = new CustomDialogController({
    builder: SetUserPreferDialog(),
    customStyle: true
  })

  startTranslate(){
    if (this.inputContent && this.inputContent.length > 0) {
      this.translation.query = this.inputContent
      this.translation.from = this.translateFrom.name
      this.translation.to = this.translateTo.name

      this.startTranslateByBaiduMachineGeneral()
    }



  }

  startTranslateByBaiduMachineGeneral() {
      BaiduHttpUtil.translateByMachineGeneral(this.translateFrom.code, this.translateTo.code, this.inputContent, this.baidu_access_token, (data: TranslationGroup) => {
        this.translation.translations.push(data)
      });
  }
  startTranslateByBaiduGeneralApi(){

  }
  startTranslateByYoudaoApi(){

  }



  build() {
    Column() {
      MainPageTopSwiper()

      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: $r('app.string.text_to_be_translated') })
          .layoutWeight(1)
          .margin(10)
          .padding(10)
          .backgroundColor(Color.Gray)
          .borderRadius(10)
          .fontColor(Color.White)
          .onChange((value) => {


            this.inputContent = value
            console.log('上次timer id ——>' + this.queryTimer)
            if (this.queryTimer != 0) {
              clearTimeout(this.queryTimer)
            }
            if (this.translate_type == 'immediately') {
              this.queryTimer = setTimeout(this.startTranslate.bind(this), 500)
            } else {
              console.error('需要点击发送按钮才会进行翻译')
            }
          })
          .enterKeyType(EnterKeyType.Done)
          .onSubmit(() => {
            this.startTranslate();
          })
        Image($r('app.media.menu'))
          .margin({ right: 10 })
          .width(40)
          .height(40)
          .bindMenu([
            {
              value: "设置key",
              action: () => {
                if (this.setAppInfoDialogController != undefined) {
                  this.setAppInfoDialogController.open()
                }
              }
            },
            {
              value: "偏好设置",
              action: () => {
                if (this.setUserPreferDialogController != undefined) {
                  this.setUserPreferDialogController.open()

                }
              }
            }
          ])
      }


      Stack({ alignContent: Alignment.End }) {
        Row() {
          Text(this.translateFrom.name).margin(10).width('40%')
            .onClick(() => {
              if (this.selectLanguageDialogController != undefined) {
                this.changeFromLanguageType = true;
                this.changeToLanguageType = false;
                this.selectLanguageDialogController.open()
              }
            }).textAlign(TextAlign.Center)
          Image($r("app.media.switch_language_positions")).width(23).height(20).onClick(() => {
            [this.translateTo, this.translateFrom] = [this.translateFrom, this.translateTo];
          })
          Text(this.translateTo.name).margin(10).width('40%')
            .onClick(() => {
              this.changeFromLanguageType = false;
              this.changeToLanguageType = true;
              this.selectLanguageDialogController.open()
            }).textAlign(TextAlign.Center)
        }.justifyContent(FlexAlign.SpaceAround).width('100%')
      }.width('100%')

      TranslationResultView()

    }
    .width('100%')
  }
}