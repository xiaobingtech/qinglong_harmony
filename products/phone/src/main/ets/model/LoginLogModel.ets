export interface LoginLogModelData {
  timestamp: number;
  address: string;
  ip: string;
  platform: string;
  status: number;
}

export interface LoginLogModel {
  code: number;
  data: LoginLogModelData[];
}