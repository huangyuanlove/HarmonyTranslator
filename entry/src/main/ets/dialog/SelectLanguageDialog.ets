import { LanguageGroup, TranslateLanguage } from '../model/TranslateResult'

@CustomDialog
struct SelectLanguageDialog {
  @StorageLink('translate_from_name') translateFrom: TranslateLanguage = new TranslateLanguage('中文', 'zh')
  @StorageLink('translate_to_name') translateTo: TranslateLanguage = new TranslateLanguage('英文', 'en')
  controller: CustomDialogController
  confirm: (selectLanguage: TranslateLanguage) => void
  languageMap: Object;
  dataForShow: LanguageGroup[] = []
  @Prop selectFromLang:boolean ;

  objectToList(obj: { [key: string]: any }): TranslateLanguage [] {
    const result: TranslateLanguage[] = [];
    for (const key in obj) {
      if (Object.hasOwnProperty.call(obj, key)) {
        if(this.selectFromLang){
          if(key != this.translateFrom.name){
            result.push(new TranslateLanguage(key, obj[key]));
          }
        }else{
          if(key != this.translateTo.name){
            result.push(new TranslateLanguage(key, obj[key]));
          }
        }


      }
    }
    return result;
  }

  aboutToAppear() {
    console.error("SelectLanguageDialog aboutToAppear -->" + this.translateFrom.name)

    const allLanguage: TranslateLanguage [] = this.objectToList(this.languageMap)

    const oftenLang:TranslateLanguage []=[];
    allLanguage.forEach(element => {
      if(oftenLang.length<6 ){
        if(this.selectFromLang){
          if(element.name != this.translateFrom.name){
            oftenLang.push(element)
          }
        }else{
          if(element.name != this.translateTo.name && !element.name.includes("自动") &&! !element.name.includes("检测")){
            oftenLang.push(element)
          }
        }
      }
    });

    //粗暴的取前6个，没有对之前选择的做存储
    this.dataForShow.push(new LanguageGroup("常用", allLanguage.slice(0,6)))

    this.dataForShow.push(new LanguageGroup("全部", allLanguage))


  }

  @Builder itemHead(text: string) {
    Text(text)
      .fontSize(20)
      .width("100%")
      .backgroundColor(Color.White)
      .padding(10)
  }


  build() {
    List({ space: 20 }) {
      ListItemGroup({ header: this.itemHead(this.dataForShow[0].groupName) }) {
        ListItem() {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.dataForShow[0].languages, (language: TranslateLanguage) => {
              Text(language.name)
                .padding({ top: 4, bottom: 4, left: 15, right: 15 })
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
            })
          }
        }

      }

      ListItemGroup({ header: this.itemHead(this.dataForShow[1].groupName) }) {
        ForEach(this.dataForShow[1].languages, (language: TranslateLanguage) => {
          ListItem() {
            Text(language.name)
              .width('30%')
              .padding({ top: 4, bottom: 4, left: 15, right: 15 })
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
          return language.code + this.dataForShow[1].groupName
        })
      }
    }
    .width('80%')
    .height('60%')
    .backgroundColor(Color.White)
    .borderRadius(6)
    .sticky(StickyStyle.Header)

  }
}

export default SelectLanguageDialog