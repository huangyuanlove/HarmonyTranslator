import { BaiduAIDictTranslationResult } from '../model/TranslateResult'
import { AVPlayerHelper,AVPlayerStateCallback } from '../util/AVPlayerHelper';

@Component
export default struct BaiduAIDictTranslationResultView {
  @Consume('baidu_ai_dict_translation_result') result: BaiduAIDictTranslationResult
  @State playSrcTTSAnimatorState: AnimationStatus = AnimationStatus.Initial
  @State playDstTTSAnimatorState: AnimationStatus = AnimationStatus.Initial
  private avPlayerHelper: AVPlayerHelper;

  aboutToAppear() {
    this.avPlayerHelper = AVPlayerHelper.instance
  }




  @Builder
  buildDictView(json:Object):void{
    if(json){


    }
  }


  build() {
    Column() {
      if (this.result.errorMessage && this.result.errorMessage.length > 0) {
        Text(JSON.stringify(this.result))
      } else {

          Column() {
            Row() {
              Text(this.result.result.dst).fontSize(26).margin(10)
              ImageAnimator().margin(10)
                .images([
                  { src: $r('app.media.voice1'), width: 24, height: 24 },
                  { src: $r('app.media.voice2'), width: 24, height: 24 },
                  { src: $r('app.media.voice3'), width: 24, height: 24 },
                ])
                .duration(600)
                .state(this.playDstTTSAnimatorState)
                .onClick(() => {


                  this.avPlayerHelper.playWithUrl(this.result.result.dst_tts,(state:string)=>{
                      switch(state){
                          case 'playing':
                            console.error('dst state playing called')
                            this.playDstTTSAnimatorState = AnimationStatus.Running
                            break;
                          case 'paused':
                            console.error('dst state paused called')
                            this.playDstTTSAnimatorState = AnimationStatus.Paused
                            break;
                          case 'completed':
                            console.error('dst state completed called')
                            this.playDstTTSAnimatorState = AnimationStatus.Stopped
                            break;
                          case 'stopped':
                            console.error('dst state stopped called')
                            this.playDstTTSAnimatorState = AnimationStatus.Stopped
                            break;
                      }
                  })
                  }
                )
                .fillMode(FillMode.None)
                .reverse(true)
                .iterations(-1)
                .width(24)
                .height(24)

            }.width('100%').justifyContent(FlexAlign.Start)

            Row() {
              Text(this.result.result.src).fontSize(26).margin(10)
              ImageAnimator()
                .margin(10)
                .images([
                  { src: $r('app.media.voice1'), width: 24, height: 24 },
                  { src: $r('app.media.voice2'), width: 24, height: 24 },
                  { src: $r('app.media.voice3'), width: 24, height: 24 },
                ])
                .duration(1000)
                .state(this.playSrcTTSAnimatorState)
                .onClick(() => {
                  this.avPlayerHelper.playWithUrl(this.result.result.src_tts,(state:string)=>{
                    switch(state){
                      case 'playing':
                        console.error('src state playing called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Running
                        break;
                      case 'paused':
                        console.error('src state paused called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Paused
                        break;
                      case 'completed':
                        console.error('src state completed called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Stopped
                        break;
                      case 'stopped':
                        console.error('src state stopped called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Stopped
                        break;
                    }
                  })
                })
                .fillMode(FillMode.None)
                .reverse(true)
                .iterations(-1)
                .width(24)
                .height(24)
            }.width('100%').justifyContent(FlexAlign.Start)

            Text(JSON.stringify(this.result.result.dict))
          }
          .margin({ left: 15, right: 15, top: 20 })
          .padding(10)
          .backgroundColor(0XEEEEEE)
          .backdropBlur(10)
          .width('100%')
          .borderRadius(4)


      }


    }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).height('100%')
  }
}