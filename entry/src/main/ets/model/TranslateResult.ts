export class TranslationResult{
  query:string
  translations: TranslationGroup[]
  from:string
  to:string

}

export class TranslationGroup{
  apiName:string
  dst:string[]
  error:string
  log_id:number
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
    return new TranslateLanguage(json['name'],json['code']);
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

export class PartMeans{
  means:string[]
  part:string
  text:string
  wordMean:string

  static fromJSON(json:Object):PartMeans{
    let tmp = new PartMeans();
    tmp.part = json['part']
    tmp.text = json['text']
    tmp.wordMean = json['word_mean']

    let meansJSON:JSON[] = json['means']
    if(meansJSON && meansJSON.length > 0){
      tmp.means = []
      meansJSON.forEach(mean=>{
        tmp.means.push(JSON.stringify(mean))
      })
    }

    return tmp
  }

}


export class Symbols{
  wordSymbol:string
  means:PartMeans[]

  static fromJSON(json:Object):Symbols{
    let tmp = new Symbols();
    tmp.wordSymbol = json['word_symbol']
    let parts:JSON[] = json['parts']
    if(parts && parts.length > 0){
        let meansJSON:JSON[] = parts[0]['means']
        if(meansJSON && meansJSON.length > 0){
          tmp.means = []
          meansJSON.forEach(meanJSON=>{
              let mean:PartMeans = PartMeans.fromJSON(meanJSON)
              if(mean){
                tmp.means.push(mean)
              }
          })
        }
    }
    return tmp;
  }
}

export class BaiduAIDictSimpleMeans{
  wordMeans:string[]
  from:string
  wordName:string
  symbols:Symbols

  static fromJSON(json:Object):BaiduAIDictSimpleMeans{
    let tmp = new BaiduAIDictSimpleMeans();
    tmp.from = json['from']
    tmp.wordName = json['word_name']
    let means:JSON[] = json['word_means']
    if(means){
      tmp.wordMeans = []
      means.forEach( mean =>{
        tmp.wordMeans.push(JSON.stringify(mean))
      })
    }
    let symbolsJSON:JSON[] = json['symbols']
    if(symbolsJSON && symbolsJSON.length >0){
      tmp.symbols = Symbols.fromJSON(symbolsJSON[0])
    }
    return tmp;
  }

}

export class WordResult{
  simpleMeans:BaiduAIDictSimpleMeans

  static fromJSON(json:Object):WordResult{
    let tmp:WordResult = new WordResult();

    let worResult:JSON = JSON.parse(json as string)['word_result']

    tmp.simpleMeans = BaiduAIDictSimpleMeans.fromJSON(worResult['simple_means'])
    return tmp
  }

}


export class BaiduAIDictTranslationResult{
  errorCode:string
  errorMessage:string
  logId:string
  result:{dst:string,dst_tts:string, src:string,src_tts:string,dict:WordResult}

  static fromJSON(json:object):BaiduAIDictTranslationResult{
    let tmp = new BaiduAIDictTranslationResult()
    tmp.errorCode = json['error_code']
    tmp.errorMessage = json['error_msg']
    tmp.logId = json['log_id']
    let resultJSON = json['result']
    if(resultJSON){
      let trans_result_arr: JSON [] = resultJSON['trans_result']
      if (trans_result_arr && trans_result_arr.length > 0) {
        let trans_result = trans_result_arr[0]
        let dict:WordResult = WordResult.fromJSON(trans_result['dict'])
        tmp.result = {dst: trans_result['dst'],dst_tts:trans_result['dst_tts'],src:trans_result['src'],src_tts:trans_result['src_tts'],dict:dict}

      }
    }
    return tmp;
  }

}


export class BaiduAIGeneralTranslationResult{
  errorCode:string
  errorMessage:string
  logId:string
  result:{dst:string,src:string}[]


  static fromJSON(json:object):BaiduAIGeneralTranslationResult{
    let tmp = new BaiduAIGeneralTranslationResult()
    tmp.errorCode = json['error_code']
    tmp.errorMessage = json['error_msg']
    tmp.logId = json['log_id']
    let resultJSON = json['result']
    if(resultJSON){
      let trans_result_arr: JSON [] = resultJSON['trans_result']
      if (trans_result_arr && trans_result_arr.length > 0) {
        tmp.result = []
        trans_result_arr.forEach(trans_result => {
          tmp.result.push( {dst: trans_result['dst'],src:trans_result['src']});
        })
      }
    }

    return tmp
  }

}

