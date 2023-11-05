import router from '@ohos.router'
import Prompt from '@system.prompt'
import promptAction from '@ohos.promptAction'
import MediaQuery from '@system.mediaquery'
import mediaquery from '@ohos.mediaquery'

@Entry
@Component
struct SettingPage {

  private select: number  = 0
  private apiType: string[] = ['百度通用文本翻译', '百度机器翻译：文本翻译-通用版', '有道智云：文本翻译']

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

      }.width('100%')
      .padding(15).margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(()=>{
        TextPickerDialog.show({
          range: this.apiType,
          selected: this.select,
          onAccept: (value: TextPickerResult) => {
            // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
            this.select = value.index
            console.error("TextPickerDialog:onAccept()" + JSON.stringify(value))
            promptAction.showToast({message:"不要忘记设置对应的api key"})

          },
          onCancel: () => {
            console.error("TextPickerDialog:onCancel()")
          },
          onChange: (value: TextPickerResult) => {
            console.error("TextPickerDialog:onChange()" + JSON.stringify(value))
          }
        })
      })


      Row() {
        Text("百度通用文本翻译").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({left:15})
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }.width('100%')
      .padding(15).margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(()=>{
        try {
          promptAction.showActionMenu({

            buttons: [
              {
                text: '百度通用文本翻译',
                color: '#000000',
              },
              {
                text: '百度机器翻译：文本翻译-通用版',
                color: '#999999',
              },{
                text: '有道智云：文本翻译',
                color: '#999999',
              },
            ]
          }, (err, data) => {
            if (err) {
              console.info('showActionMenu err: ' + err);
              return;
            }
            console.info('showActionMenu success callback, click button: ' + data.index);
          })
        } catch (error) {
          console.error(`showActionMenu args error code is ${error.code}, message is ${error.message}`);
        };
      })

      Row() {
        Text("百度机器翻译：文本翻译-通用版").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({left:15})
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }.width('100%')
      .padding( 15).margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(()=>{
        promptAction.showToast({message:"开发中~~",bottom:500})
      })

      Row() {
        Text("有道智云：文本翻译").textAlign(TextAlign.Center).fontColor(Color.Black)
        Image($r('app.media.tip')).width(20).height(20).margin({left:15})
        Blank()
        Image($r('app.media.right_arrow')).width(20).height(20)

      }.width('100%')
      .padding(15).margin({ top: 15 })
      .backgroundColor(0xE5E5E5)
      .onClick(()=>{
        promptAction.showToast({message:"开发中"})
      })
    }.padding({ top: 48 })
  }
}