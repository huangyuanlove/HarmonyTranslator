export class TranslationResult {
  query: string
  translations: TranslationGroup[]
  from: string
  to: string
}

export class TranslationGroup {
  apiName: string
  dst: string[]
  error: string
  log_id: number
}


export class TranslateLanguage {
  constructor(name: string, code: string) {
    this.name = name
    this.code = code
  }

  name: string
  code: string

  toJSON(): object {
    return {
      name: this.name,
      code: this.code,
    };
  }

  static fromJSON(json: object): TranslateLanguage {
    return new TranslateLanguage(json['name'], json['code']);
  }
}


export class LanguageGroup {
  constructor(groupName: string, languages: TranslateLanguage[]) {
    this.groupName = groupName
    this.languages = languages
  }

  groupName: string
  languages: TranslateLanguage[]
}


export class MeansInSimple {
  means: string[]
  part: string
  text: string
}

export class BaiduAIDictSimpleMeans {
  from: string
  word_symbol: string
  word_name:string
  means: MeansInSimple[]

  static fromJSON(json: Object): BaiduAIDictSimpleMeans {
    let tmp = new BaiduAIDictSimpleMeans()
    if (json) {
      tmp.from = json['from']
      tmp.word_name = json['word_name']
      let symbolsJSON: JSON[] = json['symbols']
      if (symbolsJSON && symbolsJSON.length > 0) {
        tmp.word_symbol = symbolsJSON[0]['word_symbol']

        //由于输入不会有回车，这里 parts 只会返回一个，parts.means也只会有一个
        let partsJSON: JSON[] = symbolsJSON[0]['parts']
        if (partsJSON && partsJSON.length > 0) {
          let meansJSON: JSON[] = partsJSON[0]['means']
          if (meansJSON && meansJSON.length > 0) {
            tmp.means = []
            meansJSON.forEach((json) => {
              let mean: MeansInSimple = new MeansInSimple()
              mean.part = json['part']
              mean.text = json['text']
              if (mean.text && mean.text.length > 0) {

              } else {
                mean.text = json['word_mean']
              }

              let meansInMeansJSON: JSON[] = json['means']
              if (meansInMeansJSON && meansInMeansJSON.length > 0) {
                mean.means = []
                meansInMeansJSON.forEach((value) => {
                  mean.means.push(JSON.stringify(value))
                })
              }
              tmp.means.push(mean)
            })
          }
        }
      }
    }


    return tmp
  }
}


export class WordResult {
  simpleMeans: BaiduAIDictSimpleMeans

  static fromJSON(json: Object): WordResult {
    let tmp: WordResult = new WordResult();

    let worResult: JSON = JSON.parse(json as string)['word_result']
    tmp.simpleMeans = BaiduAIDictSimpleMeans.fromJSON(worResult['simple_means'])
    return tmp
  }
}

export class BaiduAIDictResult{
  dst:string
  dst_tts: string
  src: string
  src_tts: string
  dict: WordResult

  static fromJSON(json:Object):BaiduAIDictResult{
    let tmp = new BaiduAIDictResult()
    if(json){
      tmp.dst = json['dst']
      tmp.dst_tts = json['dst_tts']
      tmp.src = json['src']
      tmp.src_tts = json['src_tts']
      let dictJSON:JSON = json['dict']
      if(dictJSON){
        tmp.dict = WordResult.fromJSON(dictJSON)
      }
      console.error("---dict----" + tmp.dict + " type" +(typeof tmp.dict ))

    }
    return tmp;
  }


}


export class BaiduAIDictTranslationResult {
  errorCode: string
  errorMessage: string
  logId: string
  result: BaiduAIDictResult

  static fromJSON(json: object): BaiduAIDictTranslationResult {
    let tmp = new BaiduAIDictTranslationResult()
    tmp.errorCode = json['error_code']
    tmp.errorMessage = json['error_msg']
    tmp.logId = json['log_id']
    let resultJSON = json['result']
    if (resultJSON) {
      let trans_result_arr: JSON [] = resultJSON['trans_result']
      if (trans_result_arr && trans_result_arr.length > 0) {
        let trans_result = trans_result_arr[0]

        // let dictJSON: JSON = trans_result['dict'];
        // let dict: WordResult
        // if (dictJSON) {
        //   dict = WordResult.fromJSON(dictJSON)
        // }
        //
        // let result:BaiduAIDictResult = new BaiduAIDictResult()

        tmp.result = BaiduAIDictResult.fromJSON(trans_result)

      }
    }
    return tmp;
  }
}


export class BaiduAIGeneralTranslationResult {
  errorCode: string
  errorMessage: string
  logId: string
  result: {
    dst: string,
    src: string
  }[]


  static fromJSON(json: object): BaiduAIGeneralTranslationResult {
    let tmp = new BaiduAIGeneralTranslationResult()
    tmp.errorCode = json['error_code']
    tmp.errorMessage = json['error_msg']
    tmp.logId = json['log_id']
    let resultJSON = json['result']
    if (resultJSON) {
      let trans_result_arr: JSON [] = resultJSON['trans_result']
      if (trans_result_arr && trans_result_arr.length > 0) {
        tmp.result = []
        trans_result_arr.forEach(trans_result => {
          tmp.result.push({ dst: trans_result['dst'], src: trans_result['src'] });
        })
      }
    }

    return tmp
  }
}

