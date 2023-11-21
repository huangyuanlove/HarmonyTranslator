import router from '@ohos.router';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
@Component
export struct MainPageTopSwiper {
  build() {
    Swiper() {
      Column() {
        Text("百度通用文本翻译API")
          .textAlign(TextAlign.Center)
          .fontSize(30)
        Row() {
          Text("链接：https://fanyi-api.baidu.com/product/11")
          Text("复制")
          Text("访问").onClick(() => {
            router.pushUrl({
              url: 'pages/ApplyTranslateKey',
              params: { 'url': 'https://fanyi-api.baidu.com/product/11' }
            })
          })
        }
      }.cardContainerStyle()


      Column() {
        Text("百度机器翻译：文本翻译-通用版").titleStyle()

        Row() {
          Text("链接：https://ai.baidu.com/ai-doc/MT/4kqryjku9")
          Text("复制")
          Text("访问").onClick(() => {
            router.pushUrl({
              url: 'pages/ApplyTranslateKey',
              params: { 'url': 'https://ai.baidu.com/ai-doc/MT/4kqryjku9' }
            })
          })
        }
      }.cardContainerStyle()

      Column() {
        Text("有道智云：文本翻译").titleStyle()
        Row() {
          Text("链接：https://ai.youdao.com/DOCSIRMA/html/trans/api/wbfy/index.html")
          Text("复制").onClick(()=>{
            pasteboard.createData("text/html","https://ai.youdao.com/DOCSIRMA/html/trans/api/wbfy/index.html")
            promptAction.showToast({message:"已复制到剪贴板"})
          }).padding({top:4,bottom:4,left:10,right:10}).borderRadius(4).borderColor(0xE5E5E5).borderWidth(1)
        }.onClick(() => {
          router.pushUrl({
            url: 'pages/ApplyTranslateKey',
            params: { 'url': 'https://ai.youdao.com/DOCSIRMA/html/trans/api/wbfy/index.html' }
          })
        })
      }.cardContainerStyle()

    }.loop(true).margin(10).autoPlay(true)
  }
}

@Styles function cardContainerStyle() {
  .width('100%')
  .height('10%')
  .backgroundColor(Color.White)
}

@Extend(Text) function titleStyle() {
  .textAlign(TextAlign.Center)
  .fontSize(20)
}
