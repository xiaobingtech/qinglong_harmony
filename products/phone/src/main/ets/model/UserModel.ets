export interface UserModelData {
  username: string;
  avatar: string;
}

export interface UserModel {
  code: number;
  data: UserModelData;
}