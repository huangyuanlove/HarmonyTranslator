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
    var resultJSON = json['result']
    if(resultJSON){
      var trans_result_arr: JSON [] = resultJSON['trans_result']
      if (trans_result_arr && trans_result_arr.length > 0) {
        tmp.result = []
        trans_result_arr.forEach(trans_result => {
          tmp.result.push(trans_result['dst'],trans_result['src']);
        })
      }
    }

    return tmp
  }

}

