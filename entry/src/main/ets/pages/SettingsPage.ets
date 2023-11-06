import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import SelectTranslateApiDialog from '../dialog/SelectTranslateApiDialog'

@Entry
@Component
struct SettingPage {
  selectTranslateApiDialogController: CustomDialogController = new CustomDialogController({
    builder: SelectTranslateApiDialog(),
    autoCancel: true,
    customStyle: true
  })

  build() {
    Column() {
      Row() {
        Image($r('app.media.left_arrow')).width(24).height(24).onClick(() => {
          router.back()
        }).margin(15)
        Text("设置").textAlign(TextAlign.Center).fontSize(24).layoutWeight(1)
      }.alignItems(VerticalAlign.Center)

      Row() {
        Text("选择翻译接口").textAlign(TextAlign.Center).fontColor(Color.Black)
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        this.selectTranslateApiDialogController.open()
      })


      Row() {
        Text("百度通用文本翻译").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({ left: 15 })
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {

      }
      )

      Row() {
        Text("百度机器翻译：文本翻译-通用版").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({ left: 15 })
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        promptAction.showToast({ message: "开发中~~" })

      })

      Row() {
        Text("有道智云：文本翻译").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({ left: 15 })
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }
      .width('100%')
      .padding(15)
      .margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(() => {
        promptAction.showToast({ message: "开发中~~" })
      })
    }.padding({ top: 48 })
  }
}
