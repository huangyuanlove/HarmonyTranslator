

import router from '@ohos.router';
@CustomDialog
struct SetApiInfoDialog {
  controller: CustomDialogController;
  @State appid: string = ''
  @State appKey: string = ''
  @StorageLink('youdao_app_id') storageId: string = ''
  @StorageLink('youdao_secrite') storageKey: string = ''

  build() {
    Column() {

      Row() {
        Text('如何申请：百度翻译-词典版')
        Image($r('app.media.tip')).width(20).height(20)
      }.justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center).onClick(() => {
        router.pushUrl({
          url: 'pages/ApplyTranslateKey',
          params: { 'url': 'https://ai.baidu.com/ai-doc/MT/nkqrzmbpc' }
        })
      })


      TextInput({ placeholder: '请输入申请的API Key' }).onChange((value) => {
        this.appid = value.toString()
      }).margin(10).padding(10).borderRadius(10)
      TextInput({ placeholder: '请输入申请的Secret Key' })
        .onChange((value) => {
          this.appKey = value.toString()
        }).margin(10).padding(10).borderRadius(10)
      Row() {
        Text('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
            }
          })
          .backgroundColor(Color.Gray)
          .borderRadius(8)
          .fontColor(Color.White)
          .padding({ top: 10, bottom: 10, left: 15, right: 15 })
        Text('确认')
          .onClick(() => {

            this.storageId = this.appid
            this.storageKey = this.appKey
            if (this.controller != undefined) {
              this.controller.close()
            }
          })
          .backgroundColor(0X39d157)
          .borderRadius(8)
          .fontColor(Color.White)
          .padding({ top: 10, bottom: 10, left: 15, right: 15 })
      }.justifyContent(FlexAlign.SpaceAround).width('80%')
    }.margin(15).borderRadius(10).backgroundColor(Color.White).padding(10)
  }
}

export default  SetApiInfoDialog