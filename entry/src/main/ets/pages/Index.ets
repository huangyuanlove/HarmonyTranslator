import prompt from '@ohos.promptAction';
import { TranslationResult, TranslateLanguage } from '../model/TranslateResult'
import { TranslationAPI } from '../model/TranslationAPI'
import { MainPageTopSwiper } from '../view/MainPageTopSwiper';
import { BaiduHttpUtil } from '../util/BaiduHttpUtils';
import { TranslationResultView } from '../view/TranslationResultView';
import SelectLanguageDialog from '../dialog/SelectLanguageDialog';
import router from '@ohos.router';
import {
  translation_api,
  baidu_text_translation_api_key,
  baidu_text_translation_secret,
  translation_from,
  translation_to
} from '../model/GeneralConfig'
import common from '@ohos.app.ability.common';
import buffer from '@ohos.buffer';
//只能在UI页面使用，否则无法持久化数据
//用到的属性必须要要先初始化，否则不会被加载到AppStorage中
PersistentStorage.PersistProp<string>(baidu_text_translation_api_key, '')
PersistentStorage.PersistProp<string>(baidu_text_translation_secret, '')
PersistentStorage.PersistProp<TranslationAPI>(translation_api, TranslationAPI.BAIDU_GENERAL)

PersistentStorage.PersistProp<string>(translation_from, JSON.stringify( new TranslateLanguage('中文', 'zh')))
PersistentStorage.PersistProp<string>(translation_to, JSON.stringify(new TranslateLanguage('英文', 'en')))


@Entry
@Component
struct Index {
  @StorageLink(translation_api) translationApiType: TranslationAPI = TranslationAPI.BAIDU_GENERAL
  @StorageLink(translation_from) translateFrom: string = JSON.stringify(new TranslateLanguage('中文', 'zh'))
  @StorageLink(translation_to) translateTo: string = JSON.stringify(new TranslateLanguage('英文', 'en'))
  @State translation: TranslationResult = null;
  @State inputContent: string = '';
  @State changeFromLanguageType: boolean = false;
  @State changeToLanguageType: boolean = false;
  @State translationResultStr: string = "";
  //选择语言弹窗中的列表，需要根据选择的翻译api从rawFile中读取
  @State translationLanguageMap: Object = new Object();

  //计时器实现停止输入立即翻译
  private queryTimer: number = 0;
  selectLanguageDialogController: CustomDialogController;
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    this.translation = new TranslationResult()
    //初始化翻译语种
    let rawFileName = 'baidu_genera_lang.json'
    if (this.translationApiType == TranslationAPI.BAIDU_GENERAL) {

    } else if (this.translationApiType == TranslationAPI.BAIDU_MACHINE_GENERAL) {

    }
    this.context.resourceManager.getRawFileContent(rawFileName, (error, value) => {
      if (error) {
        prompt.showToast({ message: "读取出错" + JSON.stringify(error) })
        console.error("读取出错" + JSON.stringify(error))
      } else {
        const rawString: string = buffer.from(value).toString('utf-8')
        console.error("读取成功" + rawString)
        this.translationLanguageMap = JSON.parse(rawString)

      }
    })

  }

  aboutToDisappear() {
    delete this.selectLanguageDialogController, // 删除dialogController
    this.selectLanguageDialogController = undefined // 将dialogController置空

  }

  onSelectLanguage(selectLanguage: TranslateLanguage) {
    console.error('this is ?' + this)
    if (this.changeFromLanguageType) {
      this.translateFrom = JSON.stringify(selectLanguage)

    } else if (this.changeToLanguageType) {
      this.translateTo = JSON.stringify(selectLanguage)
    }

    console.error('Callback when the second button is clicked')
    prompt.showToast({ message: "选择的语言--> " + selectLanguage.name + ",code-->" + selectLanguage.code })

  }

  startTranslateByBaiduGeneralApi() {
    BaiduHttpUtil.translateByTextGeneral(this.inputContent, (result) => {

      this.translationResultStr = JSON.parse(result)['trans_result'][0]['dst'];
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
          Text(this.translateFrom).margin(10).width('40%')
            .onClick(() => {
              this.changeFromLanguageType = true;
              this.changeToLanguageType = false;
              if (this.selectLanguageDialogController == undefined) {
                this.selectLanguageDialogController = new CustomDialogController({
                  builder: SelectLanguageDialog({
                    confirm: this.onSelectLanguage.bind(this),
                    languageMap: this.translationLanguageMap,
                    selectFromLang: this.changeFromLanguageType

                  }),
                  autoCancel: true,
                  customStyle: true
                })
              }
              this.selectLanguageDialogController.open()
            }).textAlign(TextAlign.Center)
          Image($r("app.media.switch_language_positions")).width(23).height(20).onClick(() => {
            [this.translateTo, this.translateFrom] = [this.translateFrom, this.translateTo];
          })
          Text(this.translateTo).margin(10).width('40%')
            .onClick(() => {
              this.changeFromLanguageType = false;
              this.changeToLanguageType = true;

              if (this.selectLanguageDialogController == undefined) {
                this.selectLanguageDialogController = new CustomDialogController({
                  builder: SelectLanguageDialog({
                    confirm: this.onSelectLanguage.bind(this),
                    languageMap: this.translationLanguageMap,
                    selectFromLang: this.changeFromLanguageType

                  }),
                  autoCancel: true,
                  customStyle: true
                })
              }


              this.selectLanguageDialogController.open()
            }).textAlign(TextAlign.Center)
        }.justifyContent(FlexAlign.SpaceAround).width('100%')
      }.width('100%')

      if (this.translationResultStr.length > 0) {
        Text(this.translationResultStr).layoutWeight(1)
      } else {
        TranslationResultView().layoutWeight(1)
      }

      MainPageTopSwiper()

    }
    .width('100%').padding({ top: 48 })
  }
}