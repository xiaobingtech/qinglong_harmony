export interface SystemModelData {
  isInitialized: boolean;
  version: string;
  publishTime: number;
  branch: string;
  changeLog: string;
  changeLogLink: string;
}

export interface SystemModel {
  code: number;
  data: SystemModelData;
}