import { translation_api } from '../model/GeneralConfig';
import { TranslationAPI } from '../model/TranslationAPI';
@CustomDialog
export default struct SelectTranslateApiDialog {
  controller: CustomDialogController;
  confirm:(api :string)=>void

  @StorageLink(translation_api) translationApiType: string = TranslationAPI.BAIDU_GENERAL
  @State selectedApi:string = ''

aboutToAppear(){
  this.selectedApi = this.translationApiType
}


  build() {
    Column() {
      Row() {
        Radio({ value: TranslationAPI.BAIDU_GENERAL, group: 'radioGroup' })
          .checked( this.selectedApi === TranslationAPI.BAIDU_GENERAL ).enabled(true)
          .onChange((isChecked:boolean)=>{
            if(isChecked){
              this.selectedApi = TranslationAPI.BAIDU_GENERAL
            }
          })
        Text("百度通用文本翻译")

      }.width('100%')

      Row() {
        Radio({ value: TranslationAPI.BAIDU_AI_GENERAL, group: 'radioGroup' })
          .checked(this.selectedApi === TranslationAPI.BAIDU_AI_GENERAL).enabled(true)
        .onChange((isChecked:boolean)=>{
          if(isChecked){
            this.selectedApi = TranslationAPI.BAIDU_AI_GENERAL
          }
        })

        Text(){
          Span("百度机器翻译：文本翻译-通用版 ")
        }
      }.justifyContent(FlexAlign.Start).width('100%')

      Row() {
        Radio({ value: TranslationAPI.BAIDU_AI_DICT, group: 'radioGroup' })
          .checked(this.selectedApi === TranslationAPI.BAIDU_AI_DICT).enabled(true)
          .onChange((isChecked:boolean)=>{
            if(isChecked){
              this.selectedApi = TranslationAPI.BAIDU_AI_DICT
            }
          })
        Text(){
          Span("百度机器翻译：文本翻译-词典版")
        }
      }.justifyContent(FlexAlign.Start).width('100%')


      Row() {
        Radio({ value: TranslationAPI.YOUDAO_GENERAL, group: 'radioGroup' })
          .checked(false).enabled(false)
        Text(){
          Span("有道智云：文本翻译")
          Span("开发中~~").fontColor(Color.Red)
        }
      }.justifyContent(FlexAlign.Start).width('100%')

      Row() {
        Text('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
            }
          })
          .backgroundColor(0xE5E5E5)
          .borderRadius(8)
          .fontColor(Color.White)
          .padding({ top: 10, bottom: 10, left: 15, right: 15 })
        Text('确认')
          .onClick(() => {

           this.translationApiType = this.selectedApi
          if(this.confirm){
            this.confirm(this.selectedApi)
          }
            if (this.controller != undefined) {
              this.controller.close()
            }
          })
          .backgroundColor(0X39d157)
          .borderRadius(8)
          .fontColor(Color.White)
          .padding({ top: 10, bottom: 10, left: 15, right: 15 })
      }.justifyContent(FlexAlign.SpaceAround).width('80%').margin({top:20})
    }.backgroundColor(Color.White).borderRadius(10).padding(15).width('60%')

  }
}