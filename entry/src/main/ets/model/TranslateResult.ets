export class YoudaoTranslateResult {
  public static fromJSON = (json: string): YoudaoTranslateResult => {
    const jsonObject = JSON.parse(json);
    let result: YoudaoTranslateResult = new YoudaoTranslateResult()
    result.errorCode = jsonObject['errorCode']
    result.translation = jsonObject['translation']
    result.speakUrl = jsonObject['speakUrl']
    result.tSpeakUrl = jsonObject['tSpeakUrl']
    result.l = jsonObject['l']
    result.basic = Basic.fromJson(jsonObject['basic'])
    return result;
  };
  errorCode: string
  tSpeakUrl: string
  speakUrl: string
  translation: string[]
  l: string
  basic: Basic
}

class Basic {
  public static fromJson = (json: string) => {
    const jsonObject = JSON.parse(json);
    let result: Basic = new Basic()
    result.ukSpeech = jsonObject['uk-speech']
    result.usSpeech = jsonObject['us-speech']
    result.explains = jsonObject['explains']
    result.usPhonetic = jsonObject['us-phonetic']
    result.ukPhonetic = jsonObject['uk-phonetic']
    result.phonetic = jsonObject['phonetic']
    return result;
  }
  ukSpeech: string
  explains: string[]
  usSpeech: string
  usPhonetic: string
  ukPhonetic: string
  phonetic: string
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
