import prompt from '@ohos.promptAction';
import { TranslationResult, TranslateLanguage, BaiduAIGeneralTranslationResult, BaiduAIDictTranslationResult } from '../model/TranslateResult'
import { TranslationAPI } from '../model/TranslationAPI'
import { MainPageTopSwiper } from '../view/MainPageTopSwiper';
import { BaiduHttpUtil } from '../util/BaiduHttpUtils';
import { TranslationResultView } from '../view/TranslationResultView';
import SelectLanguageDialog from '../dialog/SelectLanguageDialog';
import router from '@ohos.router';
import {
  translation_api,
  baidu_ai_translation_token,
  baidu_text_translation_api_key,
  baidu_text_translation_secret,
  baidu_ai_translation_general_key,
  baidu_ai_translation_general_secret,
  baidu_ai_translation_dict_key,
  baidu_ai_translation_dict_secret,
  youdao_ai_translation_general_key,
  youdao_ai_translation_general_secret,
  source_language,
  target_language,
  BaiduToken,
} from '../model/GeneralConfig'
import common from '@ohos.app.ability.common';
import buffer from '@ohos.buffer';
import { BaiduAIGeneralTranslationResultView } from '../view/BaiduAIGeneralTranslationResultView';
import BaiduAIDictTranslationResultView from '../view/BaiduAIDictTranslationResultView';
//只能在UI页面使用，否则无法持久化数据
//用到的属性必须要要先初始化，否则不会被加载到AppStorage中
PersistentStorage.PersistProp<string>(baidu_text_translation_api_key, '')
PersistentStorage.PersistProp<string>(baidu_text_translation_secret, '')
PersistentStorage.PersistProp<string>(baidu_ai_translation_general_key, '')
PersistentStorage.PersistProp<string>(baidu_ai_translation_general_secret, '')

PersistentStorage.PersistProp<string>(baidu_ai_translation_dict_key, '')
PersistentStorage.PersistProp<string>(baidu_ai_translation_dict_secret, '')
PersistentStorage.PersistProp<string>(youdao_ai_translation_general_key, '')
PersistentStorage.PersistProp<string>(youdao_ai_translation_general_secret, '')

PersistentStorage.PersistProp<string>(translation_api, TranslationAPI.BAIDU_GENERAL)


PersistentStorage.PersistProp<TranslateLanguage>(source_language, new TranslateLanguage('中文', 'zh'))
PersistentStorage.PersistProp<TranslateLanguage>(target_language, new TranslateLanguage('英文', 'en'))
PersistentStorage.PersistProp<BaiduToken>(baidu_ai_translation_token, new BaiduToken())

@Entry
@Component
struct Index {
  @StorageLink(translation_api) @Watch('onApiChange') translationApiType: string = TranslationAPI.BAIDU_GENERAL
  @StorageLink(source_language) sourceLanguage: TranslateLanguage = new TranslateLanguage('中文', 'zh')
  @StorageLink(target_language) targetLanguage: TranslateLanguage = new TranslateLanguage('英文', 'en')
  @StorageLink(baidu_ai_translation_token) baiduToken: BaiduToken = new BaiduToken()
  @State translation: TranslationResult = null;
  @State inputContent: string = '';
  @State changeFromLanguageType: boolean = false;
  @State changeToLanguageType: boolean = false;
  @State translationResultStr: string = "";
  //选择语言弹窗中的列表，需要根据选择的翻译api从rawFile中读取
  @State translationLanguageMap: Object = new Object();

  //百度机器通用文本翻译
  @Provide('baidu_ai_general_translation_result') baiduAiGeneralTranslationResult: BaiduAIGeneralTranslationResult = undefined
  @Provide('baidu_ai_dict_translation_result') baiduAiDictTranslationResult: BaiduAIDictTranslationResult = undefined

  //计时器实现停止输入立即翻译
  private queryTimer: number = 0;
  selectLanguageDialogController: CustomDialogController;
  private context = getContext(this) as common.UIAbilityContext;

  onApiChange(propName: string): void {
    console.error("translationApiType change-->" + propName)
    this.init()
  }

  private init(): void {
    let rawFileName = 'baidu_general_lang.json'
    if (this.translationApiType == TranslationAPI.BAIDU_GENERAL) {
      console.error("应该从 百度通用翻译语种文件中读取")
    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_GENERAL) {
      rawFileName = 'baidu_ai_general_lang.json'
      console.error("应该从 百度机器翻译语种文件中读取")
    }
    this.context.resourceManager.getRawFileContent(rawFileName, (error, value) => {
      if (error) {
        prompt.showToast({ message: "读取出错" + JSON.stringify(error) })
        console.error("读取出错" + JSON.stringify(error))
      } else {
        const rawString: string = buffer.from(value).toString('utf-8')
        console.error("读取成功" + rawString)
        this.translationLanguageMap = JSON.parse(rawString)
        //因为StorageLink获取到的数据只能是string类型，这里转一下
        if (typeof this.sourceLanguage === 'string') {
          this.sourceLanguage = JSON.parse(this.sourceLanguage as string)
        }
        if (typeof this.targetLanguage === 'string') {
          this.targetLanguage = JSON.parse(this.targetLanguage as string)
        }
        //如果切换了api，语言对应的code会变，这里处理一下;但每个语言的中文名字不尽相同


        this.sourceLanguage.code = this.translationLanguageMap[this.sourceLanguage.name]
        this.targetLanguage.code = this.translationLanguageMap[this.targetLanguage.name]

      }
    })


    if (this.translationApiType == TranslationAPI.BAIDU_AI_GENERAL || this.translationApiType == TranslationAPI.BAIDU_AI_DICT) {
      this.checkBaiduToken(undefined);
    }
  }


  private checkBaiduToken(onCheckDone:(success:boolean)=>void) {
    if (typeof this.baiduToken === 'string') {
      this.baiduToken = JSON.parse(this.baiduToken)
    }
    let currentTime = Date.now()
    //判断 token 是否可用
    let needReacquire = false
    if (this.baiduToken.access_token == undefined || this.baiduToken.access_token.length == 0) {
      needReacquire = true
    }
    if (this.baiduToken.expires_date < currentTime) {
      needReacquire = true
      console.error("baidu token 已过期")
    }
    if (needReacquire) {
      BaiduHttpUtil.getAccessToken((error, data) => {
        if (error) {
          console.error("获取百度token出错-->" +JSON.stringify(error) )
          let tmp:BaiduToken = new BaiduToken()
          tmp.error ='获取百度token出错'
          tmp.error_description =JSON.stringify(error)
          this.baiduToken = tmp
          if(onCheckDone){
            onCheckDone(false);
          }
        } else {
          let tmp:BaiduToken = new BaiduToken()
          tmp.access_token = data.access_token
          tmp.expires_in = data.expires_in
          tmp.expires_date = Date.now() + (data.expires_in * 1000)
          tmp.error = null
          tmp.error_description = null
          this.baiduToken = tmp
          if(onCheckDone){
            onCheckDone(true);
          }
        }
      })
    }else{
      if(onCheckDone){
        onCheckDone(true);
      }
      console.error("baidu token 正常")
    }
  }

  aboutToAppear() {


    this.translation = new TranslationResult()
    //初始化翻译语种
    this.init()

  }

  aboutToDisappear() {
    delete this.selectLanguageDialogController, // 删除dialogController
    this.selectLanguageDialogController = undefined // 将dialogController置空

  }

  onSelectLanguage(selectLanguage: TranslateLanguage) {

    if (this.changeFromLanguageType) {
      this.sourceLanguage = selectLanguage
    } else if (this.changeToLanguageType) {
      this.targetLanguage = selectLanguage
    }


    prompt.showToast({ message: "选择的语言--> " + selectLanguage.name + ",code-->" + selectLanguage.code })

  }

  private startTranslation() {
    this.cleanTranslationResult()
    if (this.translationApiType == TranslationAPI.BAIDU_GENERAL) {
      this.startTranslateByBaiduGeneralApi()
    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_GENERAL) {
      this.startTranslationByBaiduAIGeneral()
    } else if (this.translationApiType == TranslationAPI.BAIDU_AI_DICT) {
      this.startTranslationByBaiduAIDict()
    } else if (this.translationApiType == TranslationAPI.YOUDAO_GENERAL) {
      //todo
    }
  }

  private cleanTranslationResult():void{
    this.baiduAiGeneralTranslationResult = undefined
    this.baiduAiDictTranslationResult = undefined
    this.translationResultStr = ''
  }

  private startTranslateByBaiduGeneralApi() {
    BaiduHttpUtil.translateByTextGeneral(this.inputContent, (result) => {
      this.translationResultStr = JSON.parse(result)['trans_result'][0]['dst'];
    })
  }

  private startTranslationByBaiduAIGeneral() {
    this.checkBaiduToken((success)=>{
      if(success){
        BaiduHttpUtil.translateByAIGeneral(this.inputContent, this.baiduToken.access_token, (result) => {
          this.baiduAiGeneralTranslationResult = result
        })
      }else{
        prompt.showToast({message:'获取百度机器翻译token出错'})
      }
    });

  }

  private startTranslationByBaiduAIDict() {
    this.checkBaiduToken((success)=>{
      if(success){
        BaiduHttpUtil.translateByAIDict(this.inputContent, this.baiduToken.access_token, (result) => {
          this.baiduAiDictTranslationResult = result
        })
      }else{
        prompt.showToast({message:'获取百度机器翻译token出错'})
      }
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

            this.queryTimer = setTimeout(this.startTranslation.bind(this), 500)

          })
          .enterKeyType(EnterKeyType.Done)
          .onSubmit(() => {
            this.startTranslation();
          })

        Image($r('app.media.setting')).width(24).height(24).margin(15).onClick(() => {
          router.pushUrl({ url: 'pages/SettingsPage' })
        })
      }


      Stack({ alignContent: Alignment.End }) {
        Row() {
          Text(this.sourceLanguage.name).margin(10).width('40%')
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
            [this.targetLanguage, this.sourceLanguage] = [this.sourceLanguage, this.targetLanguage];
          })
          Text(this.targetLanguage.name).margin(10).width('40%')
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
      } else if (this.baiduAiGeneralTranslationResult) {
        BaiduAIGeneralTranslationResultView().layoutWeight(1)
      } else if(this.baiduAiDictTranslationResult){
        BaiduAIDictTranslationResultView().layoutWeight(1)
      }
      else {
        TranslationResultView().layoutWeight(1)
      }

      MainPageTopSwiper()

    }
    .width('100%').padding({ top: 48 })
  }
}