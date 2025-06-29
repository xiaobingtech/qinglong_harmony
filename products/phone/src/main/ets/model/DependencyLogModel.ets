export interface DependencyLogModelData {
  id: number;
  name: string;
  type: number;
  timestamp: string;
  status: number;
  log: string[];
  remark: string;
  createdAt: string;
  updatedAt: string;
}

export interface DependencyLogModel {
  code: number;
  data: DependencyLogModelData;
}