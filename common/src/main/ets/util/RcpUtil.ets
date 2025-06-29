/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 网络请求工具类 - 使用示例：
 * 
 * // 替换之前的代码：
 * // let response: EfRcpResponse<LoginModel> = await efRcpClientApi.post<LoginModel>({...})
 * // if (response.error) { ... }
 * // let result = response.data
 * 
 * // 新的使用方式：
 * import { RcpUtil, ApiResponse } from 'common'
 * 
 * let response: ApiResponse<LoginModel> = await RcpUtil.post<LoginModel>(url, params)
 * if (!response.success) {
 *   // 错误处理 - toast已自动显示，可以进行额外的错误处理
 *   if (response.errorCode === 401) {
 *     // 跳转到登录页
 *   }
 *   return
 * }
 * let result = response.data // T类型的数据
 */

import { connection } from '@kit.NetworkKit';
import { efRcp, efRcpClientApi, efRcpConfig, EfRcpError, EfRcpResponse } from '@yunkss/ef_rcp';
import Logger from './Logger';
import { rcp } from '@kit.RemoteCommunicationKit';
import { EfBusinessCodeInterceptor } from '@yunkss/ef_rcp/src/main/ets/rcp/EfBusinessCodeInterceptor';
import { promptAction } from '@kit.ArkUI';
import { PreferenceManager } from '../storagemanager/PreferenceManager';

const TAG: string = '[RcpUtil]';

/**
 * 统一的API响应类型，用于替代外部对EfRcpResponse的依赖
 */
export interface ApiResponse<T> {
  /**
   * 请求是否成功
   */
  success: boolean;
  
  /**
   * 响应数据，成功时包含实际数据，失败时为null
   */
  data: T | null;
  
  /**
   * 错误信息，成功时为null，失败时包含错误描述
   */
  error: string | null;
  
  /**
   * 错误代码，成功时为null，失败时包含错误代码
   */
  errorCode: number | null;
}

export class RcpUtil {

  private static instance: RcpUtil;
  public static init() {
    efRcp.setBaseURL('https://qinglong.app.xiaobingkj.com/')
      .disableLoading()
      .enableLogInterceptor()
      .addCommonHeaders({
        'User-Agent':'Mozilla/5.0 (Phone; OpenHarmony5.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 ArkWeb/4.1.6.1 Mobile'
      })
      .create()
  }

  public static getInstance(): RcpUtil {
    if (!RcpUtil.instance) {
      RcpUtil.instance = new RcpUtil();
    }
    return RcpUtil.instance;
  }

  /**
   * 执行GET请求
   * @param url 请求URL
   * @param query 请求参数
   * @returns 统一的API响应
   */
  public async get<E>(url: string, query: Record<string, Object> | rcp.FormFields | rcp.MultipartFormFields | Object): Promise<ApiResponse<E>> {
    let token = await PreferenceManager.getInstance().getValue<string>('token');
    let response = await efRcpClientApi.get<E>({
      baseURL: '',
      url: url,
      query: query,
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })

    return this.transformResponse(response);
  }

  /**
   * 执行POST请求
   * @param url 请求URL
   * @param query 请求参数
   * @returns 统一的API响应
   */
  public async post<E>(url: string, query: Record<string, Object> | rcp.FormFields | rcp.MultipartFormFields | Object): Promise<ApiResponse<E>> {
    let response = await efRcpClientApi.post<E>({
      baseURL: '',
      url: url,
      query: query
    })
    
    return this.transformResponse(response);
  }

  /**
   * 执行PUT请求
   * @param url 请求URL
   * @param query 请求参数
   * @returns 统一的API响应
   */
  public async put<E>(url: string, query: Record<string, Object> | rcp.FormFields | rcp.MultipartFormFields | Object): Promise<ApiResponse<E>> {
    let response = await efRcpClientApi.put<E>({
      baseURL: '',
      url: url,
      query: query
    })
    
    return this.transformResponse(response);
  }

  /**
   * 执行DELETE请求
   * @param url 请求URL
   * @param query 请求参数
   * @returns 统一的API响应
   */
  public async delete<E>(url: string, query: Record<string, Object> | rcp.FormFields | rcp.MultipartFormFields | Object): Promise<ApiResponse<E>> {
    let response = await efRcpClientApi.delete<E>({
      baseURL: '',
      url: url,
      query: query
    })

    return this.transformResponse(response);
  }
  /**
   * 将EfRcpResponse转换为ApiResponse
   * @param response EfRcpResponse响应
   * @returns ApiResponse
   */
  private transformResponse<T>(response: EfRcpResponse<T>): ApiResponse<T> {
    if (response.error) {
      // 显示错误提示
      promptAction.showToast({
        message: response.error.message
      });
      
      return {
        success: false,
        data: null,
        error: response.error.message,
        errorCode: response.error.code || null
      };
    }
    
    return {
      success: true,
      data: response.data || null,
      error: null,
      errorCode: null
    };
  }
}