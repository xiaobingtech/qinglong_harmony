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

import { DetailPageConstant } from '../../../../constant/DetailPageConstant';
import type { DescriptorWrapper } from '../../../../viewmodel/DescriptorWrapper';
import { CalendarPickerAttributeModifier } from '../viewmodel/CalendarPickerAttributeModifier';
import type { CalendarPickerDescriptor } from '../viewmodel/CalendarPickerDescriptor';

@Builder
export function CalendarPickerBuilder($$: DescriptorWrapper) {
  Column() {
    CalendarPicker({ hintRadius: DetailPageConstant.DATE_HINT_RADIUS })
      .width('30%')
      .attributeModifier(new CalendarPickerAttributeModifier($$.descriptor as CalendarPickerDescriptor))
  }
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .width('100%')
}