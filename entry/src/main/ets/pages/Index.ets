import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import media from '@ohos.multimedia.media';
import { HttpUtil } from '../util/HttpUtil'
import { BaiduTranslationResult, LanguageGroup, TranslateLanguage } from '../model/TranslateResult'
import { baidu_api_key, baidu_secret_key } from '../model/Config'

//只能在UI页面使用，否则无法持久化数据
PersistentStorage.PersistProp('translate_from', new TranslateLanguage('中文', 'zh'))
PersistentStorage.PersistProp('translate_to', new TranslateLanguage('英文', 'en'))
PersistentStorage.PersistProp('baidu_api_key', '')
PersistentStorage.PersistProp('baidu_secret_key', baidu_api_key)
PersistentStorage.PersistProp('baidu_access_token', baidu_secret_key)
PersistentStorage.PersistProp('translate_type', 'immediately')


@Entry
@Component
struct Index {
  @State translation: string[] = ['待翻译']
  @State sourceVoice: string = ''
  @State resultVoice: string = ''
  @State inputContent: string = '';
  @StorageLink('translate_from_name') translateFrom: TranslateLanguage = new TranslateLanguage('中文', 'zh')
  @StorageLink('translate_to_name') translateTo: TranslateLanguage = new TranslateLanguage('英文', 'en')
  @StorageLink('baidu_api_key') baidu_api_key: string = ''
  @StorageLink('baidu_access_token') baidu_access_token: string = ''
  @StorageLink('baidu_secret_key') baidu_secret_key: string = ''
  @StorageLink('translate_type') translate_type: string = 'immediately'
  @State changeFromLanguageType: boolean = false;
  @State changeToLanguageType: boolean = false;
  private queryTimer: number = 0;


  private avPlayer = null;

  aboutToAppear() {
    HttpUtil.getAccessToken('cw1ZmFg6jvGrK0ZpBr1Tz94S', 'tEkdl2nGk7pM6dt9FETSNar9KZGaf0ay', (error, data) => {
      if (error) {
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

  startTranslateByBaidu() {
    if (this.inputContent && this.inputContent.length > 0) {


      HttpUtil.translate(this.translateFrom.code, this.translateTo.code, this.inputContent, this.baidu_access_token, (err: Object, data: BaiduTranslationResult) => {
        if (err) {

        } else {
          this.translation = data.result.result
          this.sourceVoice = data.result.src_tts
          this.resultVoice = data.result.dst_tts
        }
      });
    }

  }

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
      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: $r('app.string.text_to_be_translated') })
          .layoutWeight(1)
          .margin(10)
          .padding(10)
          .backgroundColor(Color.Gray)
          .borderRadius(10)
          .fontColor(Color.White)
          .onChange((value) => {
            console.error('onInputChange-->' + value)

            this.inputContent = value
            console.log('上次timer id ——>' + this.queryTimer)
            if (this.queryTimer != 0) {
              clearTimeout(this.queryTimer)
            }
            if (this.translate_type == 'immediately') {
              this.queryTimer = setTimeout(this.startTranslateByBaidu.bind(this), 500)
            } else {
              console.error('需要点击发送按钮才会进行翻译')
            }


          })
          .enterKeyType(EnterKeyType.Done)
          .onEditChange((isEdit) => {
            console.error('isEdit-->' + isEdit)
          })
          .onSubmit((enterKeyType: EnterKeyType) => {
            this.startTranslateByBaidu();
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
      Text(this.sourceVoice).margin(10).padding(10).backgroundColor(Color.Gray).borderRadius(10).onClick(()=>{
        console.error('播放');
        if(this.avPlayer == undefined){
          media.createAVPlayer().then((video) => {
            if (video != null) {
              this. avPlayer = video;
              console.error('createAVPlayer success');
              this. avPlayer.url = this.sourceVoice
              this.avPlayer.prepare().then(() => {
                console.error('AVPlayer prepare succeeded.');
                console.error('AVPlayer state prepared called.');
                this.avPlayer.play(); // 调用播放接口开始播放
              }, (err) => {
                console.error(`Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
              });

            } else {
              console.error('createAVPlayer fail');
            }
          }).catch((error) => {
            console.error(`AVPlayer catchCallback, error message:${error.message}`);
          });
        }


      })
      Text(this.resultVoice).margin(10).padding(10).backgroundColor(Color.Gray).borderRadius(10)

      List() {
        ForEach(this.translation, (translate: string) => {
          ListItem() {
            Row() {
              Text(translate).padding(10).margin(10).backgroundColor(0XAAAAAA).fontColor(Color.White)
            }
          }
        })
      }.backgroundColor(Color.Gray)




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
    new LanguageGroup('常用', [new TranslateLanguage('中文', 'zh'), new TranslateLanguage('英文', 'en'),]),
    new LanguageGroup('全部', [new TranslateLanguage('中文', 'zh'), new TranslateLanguage('英文', 'en'), new TranslateLanguage('德语', 'de'), new TranslateLanguage('法语', 'fr'), new TranslateLanguage('日语', 'ja'), new TranslateLanguage('韩语', 'ko'),]),
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
struct SetUserPreferDialog {
  controller: CustomDialogController;
  @StorageLink('translate_type') translateType: string = 'immediately'

  build() {
    Column() {
      Text('偏好设置').width('100%').fontColor(0X333333).fontSize(20).textAlign(TextAlign.Center)
      Divider().margin({ top: 15 })
      Text('翻译时机').width('100%').fontSize(18).padding(10)

      Row() {
        Radio({ value: 'immediately', group: 'translate_type' })
          .checked(this.translateType == 'immediately')
          .onChange((isChecked: boolean) => {
            if (isChecked) {
              this.translateType = 'immediately'
            }
          })

        Text('立即翻译')
        Radio({ value: 'on_confirm', group: 'translate_type' })
          .checked(this.translateType == 'on_confirm')
          .onChange((isChecked: boolean) => {
            if (isChecked) {
              this.translateType = 'on_confirm'
            }
          })
        Text('点击确认')
      }.width('100%').justifyContent(FlexAlign.Start).padding(10)

    }
    .padding(10)
    .margin(15)
    .borderRadius(10)
    .backgroundColor(Color.White)
    .padding(10)
    .align(Alignment.Start)
  }
}


@CustomDialog
struct SetApiInfoDialog {
  controller: CustomDialogController;
  @State appid: string = ''
  @State appKey: string = ''
  @StorageLink('youdao_app_id') storageId: string = ''
  @StorageLink('youdao_secrite') storageKey: string = ''

  build() {
    Column() {

      Row() {
        Text('如何申请：百度翻译-词典版')
        Image($r('app.media.tip')).width(20).height(20)
      }.justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center).onClick(() => {
        router.pushUrl({
          url: 'pages/ApplyTranslateKey',
          params: { 'url': 'https://ai.baidu.com/ai-doc/MT/nkqrzmbpc' }
        })
      })


      TextInput({ placeholder: '请输入申请的API Key' }).onChange((value) => {
        this.appid = value.toString()
      }).margin(10).padding(10).borderRadius(10)
      TextInput({ placeholder: '请输入申请的Secret Key' })
        .onChange((value) => {
          this.appKey = value.toString()
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

            this.storageId = this.appid
            this.storageKey = this.appKey
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



