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

@Builder
export function NoMore() {
  Row() {
    Divider()
      .color($r('sys.color.ohos_id_color_text_field_sub_bg'))
      .height(1)
      .layoutWeight(1)
    Text($r('app.string.no_more'))
      .fontColor($r('sys.color.font_secondary'))
      .fontSize($r('sys.float.Caption_M'))
      .margin($r('sys.float.padding_level6'))
    Divider()
      .color($r('sys.color.ohos_id_color_text_field_sub_bg'))
      .height(1)
      .layoutWeight(1)
  }
  .alignItems(VerticalAlign.Center)
  .width('100%')
}