/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
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

import { BreakpointTypeEnum } from '../model/GlobalInfoModel';
import { BreakpointType } from '../util/BreakpointSystem';

@Builder
export function LoadingFailedView(breakpoint: BreakpointTypeEnum, handleReload?: () => void) {
  Row() {
    Column() {
      Image($r('app.media.ic_failure'))
        .draggable(false)
        .width(new BreakpointType({
          sm: $r('app.float.failure_size_sm'),
          md: $r('app.float.failure_size_md'),
          lg: $r('app.float.failure_size_md'),
        }).getValue(breakpoint))
        .aspectRatio(1)
      Text($r('app.string.server_error'))
        .fontColor($r('sys.color.font_tertiary'))
        .fontSize($r('sys.float.Body_M'))
        .margin({ top: $r('sys.float.padding_level4') })
    }
  }
  .onClick(() => handleReload?.())
  .width('100%')
  .height('100%')
  .backgroundColor($r('sys.color.background_secondary'))
  .justifyContent(FlexAlign.Center)
}