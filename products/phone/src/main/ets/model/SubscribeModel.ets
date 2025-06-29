export interface SubscribeModelData {
  id: number;
  name: string;
  url: string;
  schedule: string;
  // interval_schedule?: any;
  type: string;
  whitelist: string;
  blacklist: string;
  status: number;
  dependences: string;
  extensions: string;
  sub_before: string;
  sub_after: string;
  branch: string;
  // pull_type?: any;
  // pull_option?: any;
  pid: number;
  is_disabled: number;
  log_path: string;
  schedule_type: string;
  alias: string;
  // proxy?: any;
  autoAddCron: boolean;
  autoDelCron: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface SubscribeModel {
  code: number;
  data: SubscribeModelData[];
}