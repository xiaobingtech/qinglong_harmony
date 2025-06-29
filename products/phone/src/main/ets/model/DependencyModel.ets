export interface DependencyModelData {
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

export interface DependencyModel {
  code: number;
  data: DependencyModelData[];
}