import { TranslationGroup } from '../model/TranslateResult'

export interface OnGetAccessTokenCallback {

  (error: Object, data: AccessTokenResult): void;
}

export interface OnTranslationCallback {
  ( data: TranslationGroup)
}

export interface OnTranslationCallBackTmp{
  (data:string)
}

export class AccessTokenResult {
  access_token: string
  expires_in: number
}