export interface LoginModel {
  code: number
  data: LoginModelData
  message: string
}

export interface LoginModelData {
  expiration: number
  token: string
  token_type: string
  code: number
  message: string
}