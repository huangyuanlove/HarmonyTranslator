import promptAction from '@ohos.promptAction';
import { BaiduAIDictTranslationResult, PartMeans } from '../model/TranslateResult'
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

  @Builder
  buildSimpleMeans(partMeans:PartMeans[]):void{
      if(partMeans){
        Flex({ wrap: FlexWrap.Wrap }){
          ForEach(partMeans,(partMean:PartMeans)=>{
            Row(){
              if(partMean.part){
                Text(partMean.part).fontStyle(FontStyle.Italic)
              }


              Text(partMean.wordMean).fontSize(16) .textAlign(TextAlign.Center).fontColor(Color.White).margin({left:4}).fontColor(0x666666)

            }.padding({ top: 4, bottom: 4, left: 15, right: 15 })



            .borderRadius(10)
            .margin(10)
            .borderWidth(1)
            .borderColor(0x333333)
            .onClick(() => {
              if(partMean.means){
                let message =''
                partMean.means.forEach((value)=>{
                  message += value
                  message += "\n"
                })

                promptAction.showDialog({title:"简明释义",message:message})
              }else{
                promptAction.showToast({message:'没有英文释义'})
              }

            })

          })
        }
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
            Text('简明释义:来源' +this.result.result.dict.simpleMeans.from +"[ " + this.result.result.dict.simpleMeans.symbols.wordSymbol +" ]")
            this.buildSimpleMeans(this.result.result.dict.simpleMeans.symbols.means)

            // Text(JSON.stringify(this.result.result.dict))
          }
          .margin({ left: 15, right: 15, top: 20 })
          .padding(10)
          .backgroundColor(0XEEEEEE)
          .backdropBlur(10)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .borderRadius(4)


      }


    }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).height('100%')
  }
}