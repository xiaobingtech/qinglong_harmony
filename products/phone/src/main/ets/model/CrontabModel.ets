export interface CrontabModelDataData {
  id: number;
  name: string;
  command: string;
  schedule: string;
  timestamp: string;
  saved: boolean;
  status: number;
  isSystem: number;
  pid: number;
  isDisabled: number;
  isPinned: number;
  log_path: string;
  labels: string[];
  last_running_time: number;
  last_execution_time: number;
  sub_id: number;
  extra_schedules?: string;
  task_before: string;
  task_after: string;
  createdAt: string;
  updatedAt: string;
}

export interface CrontabModelData {
  data: CrontabModelDataData[];
  total: number;
}

export interface CrontabModel {
  code: number;
  data: CrontabModelData;
  msg: string;
  message: string;
  statusCode: number;
  error: string;
  validation: Validation;
}

export interface Body {
  source: string;
  keys: string[];
  message: string;
}

export interface Validation {
  body: Body;
}