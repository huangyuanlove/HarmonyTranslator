import webview from '@ohos.web.webview';
import router from '@ohos.router';

@Entry
@Component
struct ApplyTranslateKey{
  webviewController: webview.WebviewController = new webview.WebviewController();


  @State url:string = ''
  @State title:string =''
  aboutToAppear(){
   this.url = router.getParams()['url']
    console.error('aboutToAppear 获取url--> ' + router.getParams()['url'])
  }

  build(){
    Column(){
      Navigation(){
        Web({ src: this.url, controller: this.webviewController}).domStorageAccess(true).mixedMode(MixedMode.All).onTitleReceive((event)=>{
          this.title = event.title
        })
      }.mode(NavigationMode.Auto).titleMode(NavigationTitleMode.Mini)
      .title(this.title)
      .hideTitleBar(false)
      .hideToolBar(false)

    }

  }
}