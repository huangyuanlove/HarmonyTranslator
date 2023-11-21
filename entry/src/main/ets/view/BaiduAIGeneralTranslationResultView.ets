import { BaiduAIGeneralTranslationResult } from '../model/TranslateResult'

@Component
export struct BaiduAIGeneralTranslationResultView {
  translationResult: BaiduAIGeneralTranslationResult

  build() {
    Column(){
      if(this.translationResult.errorMessage && this.translationResult.errorMessage.length>0){
        Text(JSON.stringify(this.translationResult))
      }else{
        ForEach(this.translationResult.result,(dst,src)=>{
          Text(`${src} : ${dst}`)
        })
      }


    }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
  }
}