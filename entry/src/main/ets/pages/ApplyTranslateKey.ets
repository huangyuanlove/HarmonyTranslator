import webview from '@ohos.web.webview';
import router from '@ohos.router';

@Entry
@Component
struct ApplyTranslateKey{
  webviewController: webview.WebviewController = new webview.WebviewController();


  @State url:string = ''
  @State title:string =''
  @State loadProgress:number = 0;
  aboutToAppear(){
   this.url = router.getParams()['url']
    console.error('aboutToAppear 获取url--> ' + router.getParams()['url'])
  }

  build(){
    Column(){
      Row() {
        Image($r('app.media.left_arrow')).width(24).height(24).onClick(() => {
          router.back()
        }).margin(15)
        Text(this.title).textAlign(TextAlign.Center).fontSize(24).layoutWeight(1)
      }.alignItems(VerticalAlign.Center)
      Progress({ value: this.loadProgress, total: 100, type: ProgressType.Linear }).width('100%')
      Web({ src: this.url, controller: this.webviewController}).domStorageAccess(true).mixedMode(MixedMode.All).onTitleReceive((event)=>{
        this.title = event.title
      }).onProgressChange((event)=>{
        this.loadProgress = event.newProgress
      })
        .width('100%').height('100%')


    }.width('100%').height('100%').padding({ top: 48 })

  }
}