export class BaiduTranslationResult{
  log_id:number
  result:TranslationResult
}

export class TranslationResult{
  from:string
  to:string
  trans_result:TransResult[]
}

export class TransResult{
  dst:string
  dst_tts:string
  src:string
  src_tts:string
  dict:Dict

}
export class Dict{
  lang:string


}


export class TranslateLanguage {
  constructor(name: string, code: string) {
    this.name = name
    this.code = code
  }

  name: string
  code: string
}


export class LanguageGroup {
  constructor(groupName: string, languages: TranslateLanguage[]) {
    this.groupName = groupName
    this.languages = languages
  }

  groupName: string
  languages: TranslateLanguage[]
}
