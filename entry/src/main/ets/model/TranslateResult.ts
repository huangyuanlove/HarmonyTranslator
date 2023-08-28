export class BaiduMachineTranslationResult{
  log_id:number
  result:BaiduMachineTransResult[]
  from:string
  to:string
}

export class BaiduMachineTransResult{
  dst:string
  src:string

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

