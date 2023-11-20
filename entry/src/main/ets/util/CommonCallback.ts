import { BaiduAIGeneralTranslationResult, TranslationGroup } from '../model/TranslateResult'

export interface OnGetAccessTokenCallback {

  (error: Object, data: AccessTokenResult): void;
}

export interface OnTranslationCallback {
  ( data: TranslationGroup):void
}

export interface OnBaiduGeneralTranslationCallback{
  (data:string):void
}
export interface OnBaiduAIGeneralTranslationCallback{
  (data:BaiduAIGeneralTranslationResult):void
}



export class AccessTokenResult {
  access_token: string
  expires_in: number
}