
import { LanguageGroup, TranslateLanguage } from '../model/TranslateResult'
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

export default  SelectLanguageDialog