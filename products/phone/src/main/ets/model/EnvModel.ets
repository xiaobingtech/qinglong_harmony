export interface EnvModelData {
  id: number;
  value: string;
  timestamp: string;
  status: number;
  position: number;
  name: string;
  remarks: string;
  createdAt: string;
  updatedAt: string;
}

export interface EnvModel {
  code: number;
  data: EnvModelData[];
}