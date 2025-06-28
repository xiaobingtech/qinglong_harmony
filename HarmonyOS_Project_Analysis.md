# HarmonyOS代码工坊项目架构分析

## 1. 项目概述

**HarmonyOS代码工坊**是华为官方打造的开源APP，旨在帮助开发者快速掌握鸿蒙应用开发技巧。该项目展示了HarmonyOS应用开发的最佳实践，支持多设备运行（手机、平板、PC/2in1、智能穿戴设备）。

### 技术栈
- **开发语言**: ArkTS
- **UI框架**: ArkUI
- **构建工具**: DevEco Studio
- **目标系统**: HarmonyOS 5.1.0+
- **SDK版本**: HarmonyOS 5.1.0 Release SDK+

---

## 2. 目录结构分析

### 2.1 整体架构
```
qinglong_harmony/
├── AppScope/                    # 应用全局配置
├── common/                      # 公共模块 (基础层)
├── features/                    # 功能模块 (业务层)
│   ├── commonbusiness/          # 公共业务组件
│   ├── componentlibrary/        # 组件库模块
│   ├── devpractices/           # 示例开发模块
│   ├── exploration/            # 探索实践模块
│   └── mine/                   # 我的模块
├── products/                   # 产品定制层
│   ├── phone/                  # 手机端产品
│   └── wearable/              # 穿戴设备产品
├── hmosword-build/             # 构建脚本
└── hvigor/                     # 构建工具配置
```

### 2.2 分层架构说明

#### 基础层 (common/)
负责提供全局基础能力，包括：
- **组件库**: 通用UI组件
- **工具类**: 窗口管理、网络请求、存储管理等
- **视图模型**: MVVM架构基类
- **路由管理**: 页面导航管理
- **常量定义**: 全局常量和枚举

#### 业务层 (features/)
按业务功能划分的模块：
- **componentlibrary**: ArkUI组件展示和交互
- **devpractices**: Sample示例代码展示
- **exploration**: 最佳实践文章和经验分享
- **mine**: 用户个人中心
- **commonbusiness**: 跨模块共享业务组件

#### 产品层 (products/)
针对不同设备的产品定制：
- **phone**: 支持手机、平板、PC/2in1设备
- **wearable**: 支持华为智能穿戴设备

---

## 3. 路由系统分析

### 3.1 路由配置

#### 页面配置 (`main_pages.json`)
```json
{
  "src": [
    "page/SplashPage"  // 启动页面
  ]
}
```

#### 路由映射 (`router_map.json`)
```json
{
  "routerMap": [
    {
      "name": "MainPage",
      "pageSourceFile": "src/main/ets/page/MainPage.ets",
      "buildFunction": "MainPageBuilder"
    }
  ]
}
```

### 3.2 路由管理架构

#### PageContext 类
基于HarmonyOS的`NavPathStack`实现路由管理：

```typescript
export class PageContext implements IPageContext {
  private readonly pathStack: NavPathStack;

  // 页面跳转
  public openPage(data: RouterParam, animated: boolean = true): void {
    this.pathStack.pushPath({
      name: data.routerName,
      param: data.param,
    }, animated);
  }

  // 页面返回
  public popPage(animated: boolean = true): void {
    this.pathStack.pop(animated);
  }

  // 页面替换
  public replacePage(data: RouterParam, animated: boolean = true): void {
    this.pathStack.replacePath({
      name: data.routerName,
      param: data.param,
    }, animated);
  }
}
```

### 3.3 多上下文路由管理
项目中创建了多个PageContext实例来管理不同模块的导航栈：
- `pageContext`: 主导航栈
- `samplePageContext`: 示例页面导航栈
- `componentListPageContext`: 组件列表导航栈
- `explorationPageContext`: 探索页面导航栈

---

## 4. 持久化存储

### 4.1 PreferenceManager 设计

采用**单例模式**管理应用数据持久化：

```typescript
export class PreferenceManager {
  private preferences?: preferences.Preferences;
  private static instance: PreferenceManager;

  public static getInstance(): PreferenceManager {
    if (!PreferenceManager.instance) {
      PreferenceManager.instance = new PreferenceManager();
    }
    return PreferenceManager.instance;
  }
}
```

### 4.2 存储功能
- **setValue<T>(key: string, value: T)**: 存储数据
- **getValue<T>(key: string)**: 获取数据
- **hasValue(key: string)**: 检查数据是否存在
- **deleteValue(key: string)**: 删除数据

### 4.3 存储用途
- 首次启动标识
- 用户设置和偏好
- 缓存的业务数据
- 组件展示状态

---

## 5. 如何新增页面

### 5.1 创建页面文件
在对应模块的`src/main/ets/`目录下创建页面：

```typescript
// 1. 创建页面组件
@Component
struct NewPage {
  build() {
    NavDestination() {
      // 页面内容
    }
    .hideTitleBar(true)
  }
}

// 2. 导出Builder函数
@Builder
export function NewPageBuilder() {
  NewPage()
}
```

### 5.2 配置路由映射
在`router_map.json`中添加路由配置：

```json
{
  "routerMap": [
    {
      "name": "NewPage",
      "pageSourceFile": "src/main/ets/page/NewPage.ets", 
      "buildFunction": "NewPageBuilder"
    }
  ]
}
```

### 5.3 页面跳转
使用PageContext进行页面导航：

```typescript
const pageContext = AppStorage.get<PageContext>('pageContext')!;
pageContext.openPage({
  routerName: 'NewPage',
  param: { /* 传递参数 */ }
});
```

### 5.4 处理页面参数
在页面组件中接收参数：

```typescript
@Component
struct NewPage {
  @State param: object = this.getUIContext().getRouterParam() || {};
  
  build() {
    // 使用param数据
  }
}
```

---

## 6. 如何删除示例代码

### 6.1 删除模块级示例
1. **删除features目录下的示例模块**：
   ```bash
   rm -rf features/devpractices     # 删除开发实践模块
   rm -rf features/exploration      # 删除探索模块
   rm -rf features/componentlibrary # 删除组件库模块
   ```

2. **更新build-profile.json5**：
   移除对应模块的构建配置：
   ```json5
   {
     "modules": [
       {
         "name": "phone",
         "srcPath": "./products/phone"
       },
       {
         "name": "common", 
         "srcPath": "./common"
       }
       // 移除其他示例模块配置
     ]
   }
   ```

### 6.2 删除页面级示例
1. **移除MainPage中的Tab页面**：
   ```typescript
   // 在MainPage.ets中删除对应的TabContent
   TabContent() {
     // ComponentListView()  // 删除此行
     // PracticesView()      // 删除此行 
     // ExplorationView()    // 删除此行
   }
   ```

2. **清理导入语句**：
   ```typescript
   // 删除不需要的import
   // import { ComponentListView } from '@ohos/componentlibrary';
   // import { PracticesView } from '@ohos/devpractices';
   ```

### 6.3 删除示例资源
1. **删除mock数据**：
   ```bash
   rm -rf common/src/main/resources/rawfile/mockdata/
   ```

2. **删除示例图片和资源**：
   ```bash
   rm -rf products/phone/src/main/resources/rawfile/image/sample/
   ```

### 6.4 清理依赖
更新`oh-package.json5`，移除不需要的依赖包。

---

## 7. 项目架构深度分析

### 7.1 MVVM架构模式

#### ViewModel基类设计
```typescript
export abstract class BaseVM<T extends BaseState> {
  protected state: T;

  public constructor(initialState: T) {
    this.state = initialState;
  }

  getState(): T {
    return this.state;
  }

  public abstract sendEvent(baseVMEvent: BaseVMEvent);
}
```

#### 状态管理
- **BaseState**: 状态基类
- **BaseVMEvent**: 事件基类
- 使用泛型确保类型安全

### 7.2 组件化设计

#### 组件分类
1. **基础组件** (common/component/): 全局复用组件
2. **业务组件** (features/*/component/): 模块特定组件
3. **页面组件** (*/view/): 完整页面级组件

#### 组件设计原则
- **单一职责**: 每个组件职责明确
- **可复用性**: 通过props实现组件复用
- **可配置性**: 支持样式和行为定制

### 7.3 服务层设计

#### 数据服务模式
```typescript
export class ComponentLibraryService {
  private static readonly MAIN_PAGE_DATA = 'MainPageData';
  
  // 获取页面数据，支持缓存
  static async getMainPageData(): Promise<ResponseData> {
    const hasCache = await PreferenceManager.getInstance()
      .hasValue(this.MAIN_PAGE_DATA);
    
    if (hasCache) {
      return await PreferenceManager.getInstance()
        .getValue<ResponseData>(this.MAIN_PAGE_DATA);
    }
    
    // 网络请求逻辑...
  }
}
```

### 7.4 响应式设计

#### 断点系统
支持多设备适配的断点系统：
- **SM**: 小屏设备 (手机竖屏)
- **MD**: 中屏设备 (手机横屏、小平板)
- **LG**: 大屏设备 (平板) 
- **XL**: 超大屏设备 (PC/2in1)

#### 布局适配
```typescript
@Component
struct ResponsiveComponent {
  @StorageProp('GlobalInfoModel') globalInfo: GlobalInfoModel = 
    AppStorage.get('GlobalInfoModel')!;

  build() {
    if (this.globalInfo.currentBreakpoint === BreakpointTypeEnum.XL) {
      // PC/2in1布局
    } else {
      // 移动端布局  
    }
  }
}
```

---

## 8. 开发最佳实践

### 8.1 代码组织
- **分层清晰**: 严格按照基础层、业务层、产品层划分
- **模块独立**: 各功能模块间低耦合
- **接口统一**: 通过common模块统一对外接口

### 8.2 性能优化
- **懒加载**: 使用`freezeWhenInactive: true`优化组件性能
- **预加载**: Tab页面支持预加载机制
- **缓存策略**: 数据请求结果本地缓存

### 8.3 多设备适配
- **响应式布局**: 基于断点系统的布局适配
- **组件复用**: 同一组件适配多种屏幕尺寸
- **交互优化**: 针对不同设备优化交互体验

### 8.4 状态管理
- **AppStorage**: 全局状态管理
- **LocalStorage**: 页面级状态管理
- **PreferenceManager**: 持久化状态管理

---

## 9. 构建和部署

### 9.1 多产品构建配置
```json5
{
  "app": {
    "products": [
      {
        "name": "default",
        "compatibleSdkVersion": "5.0.2(14)",
        "runtimeOS": "HarmonyOS"
      }
    ]
  }
}
```

### 9.2 模块化构建
支持按需构建不同设备的模块：
- **手机端**: 包含完整功能模块
- **穿戴端**: 仅包含适配的核心模块

### 9.3 Sample集成脚本
通过`hmosword-build`目录下的脚本可以：
- 自动下载依赖的Sample项目
- 更新构建配置文件
- 集成第三方示例代码

---

## 10. 总结

HarmonyOS代码工坊项目展现了企业级鸿蒙应用开发的完整架构：

### 10.1 架构优势
- **分层清晰**: 基础层、业务层、产品层职责明确
- **模块化**: 支持按需加载和独立开发
- **跨设备**: 一套代码适配多种设备
- **可扩展**: 易于添加新功能和新设备支持

### 10.2 技术亮点
- **MVVM架构**: 数据驱动的现代化架构模式
- **路由管理**: 基于NavPathStack的导航系统
- **状态管理**: 多层次的状态管理方案
- **响应式设计**: 完善的多设备适配方案

### 10.3 学习价值
- **最佳实践**: 展示HarmonyOS开发的标准范式
- **代码质量**: 高质量的代码组织和设计模式
- **工程化**: 完整的工程化开发流程
- **性能优化**: 企业级应用的性能优化实践

该项目为HarmonyOS应用开发提供了完整的参考范例，是学习鸿蒙生态应用开发的优秀教材。 