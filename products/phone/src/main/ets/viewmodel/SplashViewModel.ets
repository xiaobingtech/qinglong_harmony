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
import { ComponentListModel } from '@ohos/componentlibrary';

const TAG: string = '[SplashViewModel]';

export class SplashViewModel extends BaseVM<BaseState> {
  private pageContext: PageContext = AppStorage.get('pageContext') as PageContext;
  private componentListModel: ComponentListModel = ComponentListModel.getInstance();
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();

  public constructor() {
    super(new BaseState());
  }

  public sendEvent(eventType: SplashEventTypeEnum): void {
    if (eventType === SplashEventTypeEnum.JUMP_TO_MAIN) {
      this.jumpToMainPage();
    } else if (eventType === SplashEventTypeEnum.PRELOAD_RESOURCES) {
      this.preloadResources();
    } else if (eventType === SplashEventTypeEnum.CHECK_FIRST_START) {
      this.checkIsFirstStart();
    } else if (eventType === SplashEventTypeEnum.JUMP_TO_LOGIN) {
      this.jumpToLoginPage();
    }
  }

  private jumpToMainPage(): void {
    this.pageContext.replacePage({
      routerName: 'MainPage',
    });
  }

  private jumpToLoginPage(): void {
    this.pageContext.replacePage({
      routerName: 'LoginPage',
    });
  }

  private preloadResources(): void {
    this.componentListModel.preloadComponentData();
  }

  private checkIsFirstStart(): void {
    this.preferenceManager.hasValue('isFirstStart').then((hasResult: boolean) => {
      if (hasResult) {
        Logger.info(TAG, 'Not first startup.');
      } else {
        Logger.info(TAG, 'First startup.');
        this.preferenceManager.setValue('isFirstStart', false).then(() => {
          Logger.info(TAG, 'Put the value of startup Successfully.');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `Put the value of startup Failed, err code: ${err.code}, message: ${err.message}`);
        });
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `check startup Failed, err code: ${err.code}, message: ${err.message}`);
    });
  }
}

export enum SplashEventTypeEnum {
  JUMP_TO_MAIN = 'jumpToMainPage',
  JUMP_TO_LOGIN = 'jumpToLoginPage',
  PRELOAD_RESOURCES = 'preloadResources',
  CHECK_FIRST_START = 'checkIsFirstStart',
}