import { BaiduAIDictTranslationResult } from '../model/TranslateResult'
import { AVPlayerHelper } from '../model/AVPlayerHelper';
@Component
export default struct BaiduAIDictTranslationResultView {
  @Consume('baidu_ai_dict_translation_result') result: BaiduAIDictTranslationResult
  private avPlayerHelper: AVPlayerHelper;

  aboutToAppear() {
    this.avPlayerHelper = AVPlayerHelper.instance
  }
  build() {
    Column() {
      if (this.result.errorMessage && this.result.errorMessage.length > 0) {
        Text(JSON.stringify(this.result))
      } else {
        ForEach(this.result.result, ({dst,dst_tts,src,src_tts,dict}) => {
          Column() {
            Row() {
              Text(dst)
              Image($r('app.media.tip')).margin({left:10}).padding(10).width(40).height(40)
                .onClick(()=>{
                  this.avPlayerHelper.playWithUrl(dst_tts)
              })
            }.backgroundColor(Color.Gray)

            Row() {
              Text(src)
              Image($r('app.media.tip')).margin({left:10}).padding(10).width(40).height(40)
                .onClick(()=>{
                this.avPlayerHelper.playWithUrl(src_tts)
              })
            }
            Text(dict)
          }
          .margin({ left: 15, right: 15, top: 20 })
          .padding(10)
          .backgroundColor(0XEEEEEE)
          .backdropBlur(10)
          .width('100%')
          .borderRadius(4)
        })

      }


    }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).height('100%')
  }
}