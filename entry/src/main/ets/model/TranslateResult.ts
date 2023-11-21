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

export class BaiduAIDictTranslationResult{
  errorCode:string
  errorMessage:string
  logId:string
  result:{dst:string,dst_tts:string, src:string,src_tts:string,dict:string}[]

  static fromJSON(json:object):BaiduAIDictTranslationResult{
    let tmp = new BaiduAIDictTranslationResult()
    tmp.errorCode = json['error_code']
    tmp.errorMessage = json['error_msg']
    tmp.logId = json['log_id']
    let resultJSON = json['result']
    if(resultJSON){
      let trans_result_arr: JSON [] = resultJSON['trans_result']
      if (trans_result_arr && trans_result_arr.length > 0) {
        tmp.result = []
        trans_result_arr.forEach(trans_result => {
          tmp.result.push( {dst: trans_result['dst'],dst_tts:trans_result['dst_tts'],src:trans_result['src'],src_tts:trans_result['src_tts'],dict:trans_result['dict']});
        })
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

