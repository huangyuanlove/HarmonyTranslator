import { AVPlayerHelper } from '../model/AVPlayerHelper';
import { BaiduMachineTransResult } from '../model/TranslateResult'

@Component
export struct BaiduMachineTranslationResultView {
  @State translationResult: BaiduMachineTransResult[] = null
  private avPlayerHelper: AVPlayerHelper;

  aboutToAppear() {
    this.avPlayerHelper = AVPlayerHelper.instance
  }

  build() {
    if (this.translationResult) {
      List() {
        ForEach(this.translationResult, (translate: BaiduMachineTransResult) => {
          ListItem() {
            Column() {

              Row() {
                Text(translate.src).padding(10).margin(10).backgroundColor(0XAAAAAA).fontColor(Color.Black)
                Text('播放')
                  .padding(10)
                  .margin(10)
                  .backgroundColor(0XAAAAAA)
                  .fontColor(Color.Black)
                  .onClick(() => {
                    //todo 请求语音合成
                  })
              }

              Row() {
                Text(translate.dst).padding(10).margin(10).backgroundColor(0XAAAAAA).fontColor(Color.Black)
                Text('播放')
                  .padding(10)
                  .margin(10)
                  .backgroundColor(0XAAAAAA)
                  .fontColor(Color.Black)
                  .onClick(() => {
                    //todo 请求语音合成
                  })
              }

            }
            .backgroundColor(0xaa1b93e0)
            .borderRadius(10)
            .margin(10)

          }
        })
      }

    }
  }
}