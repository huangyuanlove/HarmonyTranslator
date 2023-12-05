import promptAction from '@ohos.promptAction';
import {
  BaiduAIDictSimpleMeans,
  BaiduAIDictTranslationResult,
  MeansInSimple,
  ZDictDetailMeans,
  ZDictDetailIdiom,
  BaiduAIDictSimpleMeansForEng,
  PartsForEngInSymbols

} from '../model/TranslateResult'
import { AVPlayerHelper } from '../util/AVPlayerHelper';

@Component
export default struct BaiduAIDictTranslationResultView {
  @Link result: BaiduAIDictTranslationResult
  @State playSrcTTSAnimatorState: AnimationStatus = AnimationStatus.Initial
  @State playDstTTSAnimatorState: AnimationStatus = AnimationStatus.Initial
  private avPlayerHelper: AVPlayerHelper;

  aboutToAppear() {
    this.avPlayerHelper = AVPlayerHelper.instance
  }


  /**
   * 注意，默认按值传递。当传递的参数为状态变量时，状态变量的改变不会引起@Builder方法内的UI刷新
   * 这里需要引用传递
   * @param simpleMeans
   */
  @Builder
  buildSimpleMeans($$: { simpleMeans: BaiduAIDictSimpleMeans }): void {
    Column() {
      if ($$.simpleMeans?.from) {
        Text() {
          Span('来源').fontSize(16).fontColor(Color.Black)
          Span($$.simpleMeans?.from).fontSize(18).fontColor(Color.Red).margin({ left: 10 })
        }.fontSize(16)
      }
      if ($$.simpleMeans?.word_symbol && $$.simpleMeans?.word_symbol.length > 0) {
        Text() {
          Span('读音').fontSize(16).fontColor(Color.Black)
          Span($$.simpleMeans?.word_symbol).fontSize(18).fontColor(Color.Red).margin({ left: 10 })
        }.fontSize(16)
      }
      if ($$.simpleMeans?.means) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach($$.simpleMeans?.means, (means: MeansInSimple) => {
            Row() {
              if (means?.part && means.part.length > 0) {
                Text(means?.part).fontStyle(FontStyle.Italic)
              }
              Text(means?.text)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .margin({ left: 4 })
                .fontColor(0x666666)
            }
            .padding({ top: 4, bottom: 4, left: 15, right: 15 })


            .borderRadius(10)
            .margin(10)
            .borderWidth(1)
            .borderColor(0x333333)
            .onClick(() => {
              if (means?.means) {
                let message = ''
                means?.means?.forEach((value) => {
                  message += value
                  message += "\n"
                })

                promptAction.showDialog({ title: "简明释义", message: message })
              } else {
                promptAction.showToast({ message: '没有英文释义' })
              }

            })
          })
        }
      }

    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .margin(10)
    .borderRadius(6)
    .backgroundColor(Color.White)
  }

  @Builder
  buildZDictDetailMeans($$: { means: ZDictDetailMeans[] }): void {
    if ($$.means && $$.means?.length > 0) {
      Column() {
        ForEach($$.means, (value: ZDictDetailMeans) => {
          Column() {


            Row() {
              Text() {
                Span("释义").fontColor(Color.Blue).fontSize(18)

                Span(value.main).fontColor("#333333").fontSize(18).margin({ left: 6 })
              }
            }

            Row() {
              Text() {
                Span("举例").fontColor(Color.Blue).fontSize(18)
                Span(value.sub[0]).fontColor("#333333").fontSize(18).margin({ left: 6 })
              }
            }
          }.margin(4).alignItems(HorizontalAlign.Start)
        })


      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .margin(10)
      .borderRadius(6)
      .backgroundColor(Color.White)
    }
  }

  @Builder
  buildZDictSimple($$: { means: ZDictDetailMeans[] }) {
    if ($$.means && $$.means?.length > 0) {
      Column() {
        ForEach($$.means, (value: ZDictDetailMeans) => {
          Row() {
            Text() {
              Span("释义").fontColor(Color.Blue).fontSize(18)
              Span(value.main).fontColor("#333333").fontSize(18).margin({ left: 6 })
            }
          }

        })


      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .margin(10)
      .borderRadius(6)
      .backgroundColor(Color.White)
    }
  }

  @Builder
  buildZDictIdiom($$: { idiom: ZDictDetailIdiom }): void {
    if ($$.idiom) {
      Column() {
        Row() {
          if ($$.idiom?.pinyin)
          Text() {
            Span("拼音：").fontColor(Color.Blue).fontSize(18)
            Span($$.idiom?.pinyin).fontColor("#333333").fontSize(18).margin({ left: 6 })
          }
        }

        Row() {
          if ($$.idiom?.synonyms)
          Text() {
            Span("同义词：").fontColor(Color.Blue).fontSize(18)
            Span($$.idiom?.synonyms).fontColor("#333333").fontSize(18).margin({ left: 6 })
          }
        }

        Row() {
          if ($$.idiom?.antonym)
          Text() {
            Span("反义词：").fontColor(Color.Blue).fontSize(18)
            Span($$.idiom?.antonym).fontColor("#333333").fontSize(18).margin({ left: 6 })
          }
        }

        Row() {
          if ($$.idiom?.example)
          Text() {
            Span("示例：").fontColor(Color.Blue).fontSize(18)
            Span($$.idiom?.example).fontColor("#333333").fontSize(18).margin({ left: 6 })
          }
        }

        Row() {
          if ($$.idiom?.explain)
          Text() {
            Span("释义：").fontColor(Color.Blue).fontSize(18)
            Span($$.idiom?.explain).fontColor("#333333").fontSize(18).margin({ left: 6 })
          }
        }

        Row() {
          if ($$.idiom?.from)
          Text() {
            Span("来源：").fontColor(Color.Blue).fontSize(18)
            Span($$.idiom?.from).fontColor("#333333").fontSize(18).margin({ left: 6 })
          }
        }

        Row() {
          if ($$.idiom?.grammer)
          Text() {
            Span("语法：").fontColor(Color.Blue).fontSize(18)
            Span($$.idiom?.grammer).fontColor("#333333").fontSize(18).margin({ left: 6 })
          }
        }

      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .margin(10)
      .borderRadius(6)
      .backgroundColor(Color.White)
    }
  }

  @Builder
  buildSimpleForEng($$: { simpleMeansForEng: BaiduAIDictSimpleMeansForEng }) {
    if ($$.simpleMeansForEng) {
      Column() {

        Text() {
          Span("来源")
          Span($$.simpleMeansForEng?.from)
        }




        if ($$.simpleMeansForEng?.symbols) {
          Row() {
            if ($$.simpleMeansForEng?.symbols?.ph_en && $$.simpleMeansForEng?.symbols?.ph_en?.length > 0) {
              Text() {
                Span("英")
                Span($$.simpleMeansForEng?.symbols?.ph_en)
              }
              .backgroundColor(Color.White).padding(2).margin(4).borderRadius(4)
            }
            if ($$.simpleMeansForEng?.symbols?.ph_am && $$.simpleMeansForEng?.symbols?.ph_am?.length > 0) {
              Text() {
                Span("美")
                Span($$.simpleMeansForEng?.symbols?.ph_am)
              }
              .backgroundColor(Color.White).padding(2).margin(4).borderRadius(4)
            }
          }
          if($$.simpleMeansForEng?.symbols?.parts && $$.simpleMeansForEng?.symbols?.parts?.length >0){
            ForEach($$.simpleMeansForEng?.symbols.parts,(part:PartsForEngInSymbols)=>{
              Row(){
                Text(part.part)
                Text(part.means.toString())
              }
            })
          }


        }


        if ($$.simpleMeansForEng?.exchange) {
          Flex({ wrap: FlexWrap.Wrap }) {
            if ($$.simpleMeansForEng?.exchange?.word_third && $$.simpleMeansForEng?.exchange?.word_third?.length > 0) {
              Text() {
                Span("第三人称单数:")
                ForEach($$.simpleMeansForEng?.exchange?.word_third, (value: string) => {
                  if (value && value.length > 0) {
                    Span(value).fontColor(Color.Blue)
                  }
                })

              }.padding(2).margin(4).borderRadius(4).backgroundColor(Color.White)
            }
            if ($$.simpleMeansForEng?.exchange?.word_pl && $$.simpleMeansForEng?.exchange?.word_pl?.length > 0) {
              Text() {
                Span("复数:")
                ForEach($$.simpleMeansForEng?.exchange?.word_pl, (value: string) => {
                  if (value && value.length > 0) {
                    Span(value).fontColor(Color.Blue)
                  }
                })

              }.padding(2).margin(4).borderRadius(4).backgroundColor(Color.White)
            }

            if ($$.simpleMeansForEng?.exchange?.word_ing && $$.simpleMeansForEng?.exchange?.word_ing?.length > 0) {
              Text() {
                Span("现在分词:")
                ForEach($$.simpleMeansForEng?.exchange?.word_ing, (value: string) => {
                  if (value && value.length > 0) {
                    Span(value).fontColor(Color.Blue)
                  }
                })

              }.padding(2).margin(4).borderRadius(4).backgroundColor(Color.White)
            }

            if ($$.simpleMeansForEng?.exchange?.word_past && $$.simpleMeansForEng?.exchange?.word_past?.length > 0) {
              Text() {
                Span("过去式:")
                ForEach($$.simpleMeansForEng?.exchange?.word_past, (value: string) => {
                  if (value && value.length > 0) {
                    Span(value).fontColor(Color.Blue)
                  }
                })

              }.padding(2).margin(4).borderRadius(4).backgroundColor(Color.White)
            }

            if ($$.simpleMeansForEng?.exchange?.word_done && $$.simpleMeansForEng?.exchange?.word_done?.length > 0) {
              Text() {
                Span("过去分词:")
                ForEach($$.simpleMeansForEng?.exchange?.word_done, (value: string) => {
                  if (value && value.length > 0) {
                    Span(value).fontColor(Color.Blue)
                  }
                })

              }.padding(2).margin(4).borderRadius(4).backgroundColor(Color.White)
            }

          }

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach($$.simpleMeansForEng?.tags, (tag) => {
              Text(tag).backgroundColor(Color.White).borderRadius(2).margin(4).padding(2)
            })
          }

        }

      }.alignItems(HorizontalAlign.Start)
    }
  }

  build() {
    Column() {
      if (this.result) {

        if (this.result.errorMessage && this.result.errorMessage.length > 0) {
          Text(JSON.stringify(this.result))
        } else {
          Column() {
            Row() {
              Text(this.result.result.dst).fontSize(26)
              ImageAnimator()
                .margin(10)
                .images([
                  { src: $r('app.media.voice1'), width: 24, height: 24 },
                  { src: $r('app.media.voice2'), width: 24, height: 24 },
                  { src: $r('app.media.voice3'), width: 24, height: 24 },
                ])
                .duration(600)
                .state(this.playDstTTSAnimatorState)
                .onClick(() => {


                  this.avPlayerHelper.playWithUrl(this.result.result.dst_tts, (state: string) => {
                    switch (state) {
                      case 'playing':
                        console.error('dst state playing called')
                        this.playDstTTSAnimatorState = AnimationStatus.Running
                        break;
                      case 'paused':
                        console.error('dst state paused called')
                        this.playDstTTSAnimatorState = AnimationStatus.Paused
                        break;
                      case 'completed':
                        console.error('dst state completed called')
                        this.playDstTTSAnimatorState = AnimationStatus.Stopped
                        break;
                      case 'stopped':
                        console.error('dst state stopped called')
                        this.playDstTTSAnimatorState = AnimationStatus.Stopped
                        break;
                    }
                  })
                }
                )
                .fillMode(FillMode.None)
                .reverse(true)
                .iterations(-1)
                .width(24)
                .height(24)

            }.width('100%').justifyContent(FlexAlign.Start)

            Row() {
              Text(this.result.result.src).fontSize(22)
              ImageAnimator()
                .margin(10)
                .images([
                  { src: $r('app.media.voice1'), width: 24, height: 24 },
                  { src: $r('app.media.voice2'), width: 24, height: 24 },
                  { src: $r('app.media.voice3'), width: 24, height: 24 },
                ])
                .duration(1000)
                .state(this.playSrcTTSAnimatorState)
                .onClick(() => {
                  this.avPlayerHelper.playWithUrl(this.result.result.src_tts, (state: string) => {
                    switch (state) {
                      case 'playing':
                        console.error('src state playing called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Running
                        break;
                      case 'paused':
                        console.error('src state paused called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Paused
                        break;
                      case 'completed':
                        console.error('src state completed called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Stopped
                        break;
                      case 'stopped':
                        console.error('src state stopped called')
                        this.playSrcTTSAnimatorState = AnimationStatus.Stopped
                        break;
                    }
                  })
                })
                .fillMode(FillMode.None)
                .reverse(true)
                .iterations(-1)
                .width(24)
                .height(24)
            }.width('100%').justifyContent(FlexAlign.Start).margin({ top: 10 })


            this.buildSimpleMeans({ simpleMeans: this.result.result.dict?.simpleMeans })
            this.buildZDictIdiom({ idiom: this.result.result.dict?.zDict?.detail?.idiom })
            this.buildZDictDetailMeans({ means: this.result.result.dict?.zDict?.detail?.means })
            this.buildZDictSimple({ means: this.result.result.dict?.zDict?.simple?.means })
            this.buildSimpleForEng({ simpleMeansForEng: this.result.result.dict?.simpleMeansForEng })

          }
          .margin({ left: 15, right: 15, top: 20 })
          .padding(10)
          .backgroundColor(0XEEEEEE)
          .backdropBlur(10)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .borderRadius(4)

        }
      }


    }.justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Center).height('100%')

  }
}