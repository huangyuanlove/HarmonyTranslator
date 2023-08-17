export class BaiduTranslationResult{
  log_id:number
  result:TransResult
  from:string
  to:string
}

export class TransResult{
  dst:string
  dst_tts:string
  src:string
  src_tts:string
  dict:Dict
  result:string[]

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

