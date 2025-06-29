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

import type { BusinessError } from '@kit.BasicServicesKit';
import { BaseState, BaseVM, Logger, PageContext, PreferenceManager } from '@ohos/common';
import { DiscoverModel } from '@ohos/exploration';
import { ComponentListModel } from '@ohos/componentlibrary';
import { SampleModel } from '@ohos/devpractices';
import { privacyManager } from '@kit.StoreKit';
import { common } from '@kit.AbilityKit';
import { accountDao, AccountModel } from '../model/AccountModel';

const TAG: string = '[LoginViewModel]';

export class LoginViewModel extends BaseVM<BaseState> {
  private pageContext: PageContext = AppStorage.get('pageContext') as PageContext;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();
  public accounts: Array<AccountModel> = []

  public constructor() {
    super(new BaseState());
  }

  public async sendEvent(eventType: LoginEventTypeEnum): Promise<void> {
    if (eventType === LoginEventTypeEnum.JUMP_TO_MAIN) {
      this.jumpToMainPage();
    } else if (eventType === LoginEventTypeEnum.PRELOAD_RESOURCES) {
      await this.preloadResources();
    } else if (eventType === LoginEventTypeEnum.CHECK_AGREE) {
      this.checkAgree();
    }
  }

  private jumpToMainPage(): void {
    this.pageContext.replacePage({
      routerName: 'MainPage',
    });
  }

  private async preloadResources(): Promise<void> {
    this.accounts = await accountDao.findAll()
  }

  private checkAgree(): void {
    try {
      let appPrivacyResults: privacyManager.AppPrivacyResult[] = privacyManager.getAppPrivacyResult();
      for (let i = 0; i < appPrivacyResults.length; i++) {
        Logger.info('TAG',
          "Succeeded in getting AppPrivacyResult type = " + appPrivacyResults[i]["type"] + ", version = " +
          appPrivacyResults[i]["versionCode"] + ", result = " + appPrivacyResults[i]["result"]);
      }
    } catch (error) {
      Logger.error('TAG', "GetAppPrivacyResultPublic exception code: " + error.code + ", exception message: " + error.message);
    }
  }
}

export enum LoginEventTypeEnum {
  JUMP_TO_MAIN = 'jumpToMainPage',
  PRELOAD_RESOURCES = 'preloadResources',
  CHECK_AGREE = 'checkAgree',
}