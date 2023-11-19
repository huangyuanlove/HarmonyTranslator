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

