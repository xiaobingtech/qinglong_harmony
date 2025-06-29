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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { BreakpointTypeEnum, CommonConstants, GlobalInfoModel, Logger, PageContext, WindowUtil, } from '@ohos/common';
import { AccountModel } from '../model/AccountModel';
import { LoginEventTypeEnum, LoginViewModel } from '../viewmodel/LoginViewModel';
import { SplashEventTypeEnum, SplashViewModel } from '../viewmodel/SplashViewModel';

const TAG: string = '[LoginPage]';

@Builder
export function LoginPageBuilder() {
  LoginPage()
}

@Entry
@Component
struct LoginPage {

  @StorageProp('GlobalInfoModel') globalInfoModel: GlobalInfoModel = AppStorage.get('GlobalInfoModel')!;
  @StorageProp('systemColorMode') @Watch('handleColorModeChange') systemColorMode: ConfigurationConstant.ColorMode =
    AppStorage.get('systemColorMode')!;

  private pageContext: PageContext = AppStorage.get('pageContext') as PageContext;
  private viewModel: LoginViewModel = new LoginViewModel();

  @State useAccount: number = 1
  @State useCode: boolean = false

  @State server: string = ''
  @State username: string = ''
  @State password: string = ''
  @State client_id: string = ''
  @State client_secret: string = ''
  @State code: string = ''
  @State remark: string = ''
  @State loading: boolean = false




  onPageHide() {
    Logger.info(TAG, 'onPageHide');
    WindowUtil.updateStatusBarColor(getContext(this),
      AppStorage.get('systemColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
  }

  handleColorModeChange() {
    const isSystemDark: boolean = (this.systemColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    WindowUtil.updateStatusBarColor(getContext(this), isSystemDark);
  }

  async aboutToAppear(): Promise<void> {
    WindowUtil.updateStatusBarColor(getContext(this), true);
    await this.viewModel.sendEvent(LoginEventTypeEnum.PRELOAD_RESOURCES);
    this.viewModel.sendEvent(LoginEventTypeEnum.CHECK_AGREE);
  }

  @Builder
  accountMenu() {
    Menu(){
      ForEach(this.viewModel.accounts, (item: AccountModel) => {
        MenuItem({content: item.server})
          .onClick(() => {
            this.server = item.server
            this.username = item.username
            this.password = item.password
            this.useAccount = item.useAccount
            this.client_id = item.client_id
            this.client_secret = item.client_secret
            this.remark = item.remark
          })
      }, (item: AccountModel) => item.server)
    }
  }

  build() {
    NavDestination() {
      Column({space: 15}) {
        if (this.loading) {
          LoadingProgress()
            .width(50)
            .height('100%')
        } else {
          Blank()
          Image($r('app.media.app_icon'))
            .width(60)
          Row(){
            TextInput({
              placeholder: '请输入服务器地址',
              text: this.server
            })
              .type(InputType.URL)
              .onChange((value) => {
                this.server = value
              })
              .borderRadius({ topLeft: 10, bottomLeft: 10 })
              .width('calc(100% - 40vp)')
            SymbolGlyph($r('sys.symbol.chevron_down'))
              .bindMenu(this.accountMenu())
              .width(40)
              .height(40)
              .fontColor([this.systemColorMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.color.font_primary_light') : $r('app.color.font_primary_dark')])
              // .fillColor(0x000000)
              .backgroundColor(this.systemColorMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.color.blur_bg') : $r('app.color.blur_bg'))
              .borderRadius({topRight: 10, bottomRight: 10})
          }
          // .borderRadius(10)
          if (this.useAccount == 1) {
            TextInput({
              placeholder: '请输入用户名',
              text: this.username
            })
              .borderRadius(10)
              .onChange((value) => {
                this.username = value
              })
            TextInput({
              placeholder: '请输入密码',
              text: this.password
            })
              .type(InputType.Password)
              .borderRadius(10)
              .onChange((value) => {
                this.password = value
              })
          } else {
            TextInput({
              placeholder: '请输入Client_Id',
              text: this.client_id
            })
              .borderRadius(10)
              .onChange((value) => {
                this.client_id = value
              })
            TextInput({
              placeholder: '请输入Client_Secret',
              text: this.client_secret,
            })
              .type(InputType.Password)
              .borderRadius(10)
              .onChange((value) => {
                this.client_secret = value
              })
          }
          if (this.useCode) {
            TextInput({
              placeholder: '请输入Code',
              text: this.code
            })
              .type(InputType.Number)
              .borderRadius(10)
              .onChange((value) => {
                this.code = value
              })
          }
          TextInput({
            placeholder: '请输入备注',
            text: this.remark
          })
            .type(InputType.Normal)
            .borderRadius(10)
            .onChange((value) => {
              this.remark = value
            })
          // Row() {
          //   Text('是否使用用户名密码')
          //   Blank()
          //   Toggle({
          //     type: ToggleType.Switch,
          //     isOn: this.useAccount == 1
          //   })
          // }
          // .width('100%')

          Button('登录')
            .enabled(this.username != '' && this.password != '' && this.server != '')
            .width('100%')
            .onClick(() => {
              this.loading = true
              if (this.useAccount) {
                // this.loginByUser(this.username, this.password, this.code)
              } else {
                // this.loginById(this.client_id, this.client_secret)
              }
            })
          Blank()
        }
      }
      .padding(15)
      .width(this.globalInfoModel.currentBreakpoint == BreakpointTypeEnum.MD ? '100%' : '30%')
      .height('100%')
      .backgroundColor(this.systemColorMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.color.icon_primary_dark') : $r('app.color.icon_primary_light'))
    }
    .hideTitleBar(true)
    .height('100%')
    .width('100%')
  }
}