import router from '@ohos.router';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';

@Component
export struct MainPageTopSwiper {

  private setPasteBoardData(content:string){
    let data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, content)
    pasteboard.getSystemPasteboard().setData(data, (error, data) => {
      if (error) {
        promptAction.showToast({ message: `复制出错--> ${JSON.stringify(error)}` })
      } else {
        promptAction.showToast({ message: "已复制到剪贴板" })
      }
    })
  }

  @Builder
  builderSwiperItem(title: string, link: string, toPage: string) {
    Column() {
      Text(title).titleStyle()
        Text(`链接：${link}`)
        Text("复制").copyViewStyle()
          .onClick(() => {
            this.setPasteBoardData(link)
          })
    }.cardContainerStyle().justifyContent(FlexAlign.Center)
    .onClick(() => {
      router.pushUrl({
        url: toPage,
        params: { 'url': link }
      })
    })
  }

  build() {
    Swiper() {
      this.builderSwiperItem('百度通用文本翻译API', "https://fanyi-api.baidu.com/product/11", "pages/ApplyTranslateKey");
      this.builderSwiperItem('百度机器翻译：文本翻译-通用版', "https://ai.baidu.com/ai-doc/MT/4kqryjku9", "pages/ApplyTranslateKey");
      this.builderSwiperItem('百度机器翻译：文本翻译-词典版', "https://ai.baidu.com/ai-doc/MT/nkqrzmbpc", "pages/ApplyTranslateKey");
      this.builderSwiperItem('有道智云：文本翻译', "https://ai.youdao.com/DOCSIRMA/html/trans/api/wbfy/index.html", "pages/ApplyTranslateKey");
    }.loop(true).margin(10).autoPlay(true)
  }
}

@Styles function cardContainerStyle() {
  .width('100%')
  .height('10%')
  .backgroundColor(Color.White)
  .margin(15)
  .borderRadius(4)
  .borderColor(0xaaaaaa)
  .borderWidth(1)
  .padding(10)
}

@Extend(Text) function titleStyle() {
  .textAlign(TextAlign.Center)
  .fontSize(20)
}
@Styles function copyViewStyle(){
  .padding({ top: 4, bottom: 4, left: 10, right: 10 })
  .borderRadius(4)
  .borderColor(0xE5E5E5)
  .borderWidth(1)
}