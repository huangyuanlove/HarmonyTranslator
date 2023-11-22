import { AVPlayerHelper } from '../util/AVPlayerHelper';
import { TranslationGroup, TranslationResult } from '../model/TranslateResult';


@Component
export struct TranslationResultView {
  @State translationResult: TranslationResult = null;
  private avPlayerHelper: AVPlayerHelper;

  aboutToAppear() {
    this.avPlayerHelper = AVPlayerHelper.instance
  }
  @Builder itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }
  build() {
    if (this.translationResult) {

      List() {
        ForEach(this.translationResult.translations, (translation:TranslationGroup) => {

          ListItemGroup({header:this.itemHead(translation.apiName)}){
            if(translation.error){
              ListItem(){
                Text(translation.error)
              }
            }else{
              ForEach(translation.dst,(dst:string)=>{
                ListItem(){
                  Row() {
                    Text(dst).padding(10).margin(10).backgroundColor(0XAAAAAA).fontColor(Color.Black)
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
              })
            }

          }
        })
      }

    }
  }
}