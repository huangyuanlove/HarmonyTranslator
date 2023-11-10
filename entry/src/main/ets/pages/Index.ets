import prompt from '@ohos.promptAction';

import { TranslationResult, TranslateLanguage } from '../model/TranslateResult'

import { TranslationAPI } from '../model/TranslationAPI'

import { MainPageTopSwiper } from '../view/MainPageTopSwiper';
import { BaiduHttpUtil } from '../util/BaiduHttpUtils';
import { TranslationResultView } from '../view/TranslationResultView';
import SelectLanguageDialog from '../dialog/SelectLanguageDialog';
import router from '@ohos.router';
//只能在UI页面使用，否则无法持久化数据
PersistentStorage.PersistProp('translate_from', new TranslateLanguage('中文', 'zh'))
PersistentStorage.PersistProp('translate_to', new TranslateLanguage('英文', 'en'))
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
  @State changeFromLanguageType: boolean = false;
  @State changeToLanguageType: boolean = false;
  private queryTimer: number = 0;

  @State translationResultStr :string = "";

  aboutToAppear() {
    this.translation = new TranslationResult()

  }

  aboutToDisappear() {
    delete this.selectLanguageDialogController, // 删除dialogController
    this.selectLanguageDialogController = undefined // 将dialogController置空

  }

  onSelectLanguage(selectLanguage: TranslateLanguage) {
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
      confirm: this.onSelectLanguage.bind(this),
    }),
    autoCancel: true,
  })


  startTranslateByBaiduGeneralApi() {
    BaiduHttpUtil.translateByTextGeneral(this.inputContent,(result)=>{

      this.translationResultStr = result;
    })
  }


  build() {
    Column() {


      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: $r('app.string.text_to_be_translated') })
          .layoutWeight(1)
          .margin(10)
          .padding(10)
          .backgroundColor(0xE5E5E5)
          .borderRadius(10)
          .fontColor(Color.Black)
          .onChange((value) => {


            this.inputContent = value
            console.log('上次timer id ——>' + this.queryTimer)
            if (this.queryTimer != 0) {
              clearTimeout(this.queryTimer)
            }

            this.queryTimer = setTimeout(this.startTranslateByBaiduGeneralApi.bind(this), 500)

          })
          .enterKeyType(EnterKeyType.Done)
          .onSubmit(() => {
            this.startTranslateByBaiduGeneralApi();
          })

        Image($r('app.media.setting')).width(24).height(24).margin(15).onClick(() => {
          router.pushUrl({ url: 'pages/SettingsPage' })
        })
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
      if(this.translationResultStr.length > 0){
        Text(this.translationResultStr).layoutWeight(1)
      }else{
        TranslationResultView().layoutWeight(1)
      }

      MainPageTopSwiper()

    }
    .width('100%').padding({ top: 48 })
  }
}