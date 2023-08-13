export class YoudaoTranslateResult{

  errorCode:string
  tSpeakUrl:string
  speakUrl:string
  translation:string[]
  l:string
  query:string
}

export class TranslateLanguage {
  constructor(name: string, code: string) {
    this.name = name
    this.code = code
  }

  name: string
  code: string
}




export class LanguageGroup{
  constructor(groupName:string,languages:TranslateLanguage[]) {
    this.groupName = groupName
    this.languages = languages
  }
  groupName:string
  languages:TranslateLanguage[]
}
