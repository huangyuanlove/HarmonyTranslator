import { BaiduAIGeneralTranslationResult } from '../model/TranslateResult'

@Component
export struct BaiduAIGeneralTranslationResultView {
  @Consume('baidu_ai_general_translation_result') translationResult: BaiduAIGeneralTranslationResult

  build() {
    Column(){
      if(this.translationResult.errorMessage && this.translationResult.errorMessage.length>0){
        Text(JSON.stringify(this.translationResult))
      }else{
        ForEach(this.translationResult.result,( {dst,src})=>{
          Text(`${src} : ${dst}`).fontSize(24)
        })
      }


    }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).height('100%')
  }
}