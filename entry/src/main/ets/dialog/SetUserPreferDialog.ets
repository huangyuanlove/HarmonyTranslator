
@CustomDialog
struct SetUserPreferDialog {
  controller: CustomDialogController;
  @StorageLink('translate_type') translateType: string = 'immediately'

  build() {
    Column() {
      Text('偏好设置').width('100%').fontColor(0X333333).fontSize(20).textAlign(TextAlign.Center)
      Divider().margin({ top: 15 })
      Text('翻译时机').width('100%').fontSize(18).padding(10)

      Row() {
        Radio({ value: 'immediately', group: 'translate_type' })
          .checked(this.translateType == 'immediately')
          .onChange((isChecked: boolean) => {
            if (isChecked) {
              this.translateType = 'immediately'
            }
          })

        Text('立即翻译')
        Radio({ value: 'on_confirm', group: 'translate_type' })
          .checked(this.translateType == 'on_confirm')
          .onChange((isChecked: boolean) => {
            if (isChecked) {
              this.translateType = 'on_confirm'
            }
          })
        Text('点击确认')
      }.width('100%').justifyContent(FlexAlign.Start).padding(10)

    }
    .padding(10)
    .margin(15)
    .borderRadius(10)
    .backgroundColor(Color.White)
    .padding(10)
    .align(Alignment.Start)
  }
}
export default  SetUserPreferDialog