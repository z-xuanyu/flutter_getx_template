# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 常用命令

### 开发运行
```bash
# 运行应用（默认设备）
flutter run

# 运行在 Chrome 浏览器
flutter run -d chrome

# 运行在特定设备（先 flutter devices 查看设备列表）
flutter run -d <device_id>

# 热重启（在运行中按 r）
# 热重载（在运行中按 R）
```

### 构建发布
```bash
# 构建 Android APK
flutter build apk

# 构建 Android App Bundle
flutter build appbundle

# 构建 iOS（需要 macOS）
flutter build ios

# 构建 Web
flutter build web
```

### 测试
```bash
# 运行所有测试
flutter test

# 运行单个测试文件
flutter test test/widget_test.dart

# 运行测试并生成覆盖率报告
flutter test --coverage
```

### 代码质量
```bash
# 静态代码分析
flutter analyze

# 格式化代码
flutter format lib/

# 清理构建缓存
flutter clean

# 获取依赖
flutter pub get

# 升级依赖
flutter pub upgrade
```

## 项目架构

这是一个基于 GetX 的 Flutter 应用模板，采用 MVC 架构模式。

### 核心架构

#### 1. 状态管理 (Store)
- **UserStore**: 管理用户认证状态、token 和用户信息
  - 继承 `GetxController`，使用 `Rx` 可观察对象
  - 自动持久化到本地存储（StorageService）
  - 提供登录/注销、token 管理、用户信息获取等功能
- **ConfigStore**: 管理应用配置
  - 首次打开标记、应用版本、语言设置
  - 支持多语言切换和持久化

#### 2. 路由与导航
- **路由配置**: `lib/common/routers/pages.dart` 定义所有路由页面
- **路由中间件**:
  - `RouterWelcomeMiddleware`: 首次打开应用时的路由跳转逻辑
  - `RouteAuthMiddleware`: 路由认证检查，未登录用户跳转到登录页
- **路由名称**: `lib/common/routers/names.dart` 集中管理路由名称常量
- **路由观察器**: `RouteObservers` 用于路由导航监听

#### 3. 网络请求
- **HttpUtil**: 统一的 HTTP 请求工具类（基于 Dio）
  - 自动处理 token 授权头（Authorization: Bearer）
  - 统一错误处理，集成 EasyLoading 提示
  - 支持 RESTful API（GET/POST/PUT/PATCH/DELETE）
  - Cookie 管理支持
- **UserAPI**: 用户相关 API 接口封装
  - 登录、获取用户信息、注销等接口
  - 返回实体类对象（如 `UserLoginResponseEntity`）

#### 4. 数据持久化
- **StorageService**: 本地存储服务
  - 基于 `shared_preferences` 封装
  - 提供类型安全的数据存取方法
  - 集中管理存储键名（`lib/common/values/storage.dart`）

#### 5. 页面结构
每个页面位于 `lib/pages/<page_name>/` 目录，包含：
- `index.dart`: 页面导出文件
- `controller.dart`: 页面逻辑控制器（继承 `GetxController`）
- `view.dart`: 页面 UI 组件
- `state.dart`: 页面状态类（可选，使用 `Rx` 变量）
- `bindings.dart`: 依赖绑定类（继承 `Bindings`）
- `widgets/`: 页面专用组件目录

### 目录结构说明

```
lib/
├── main.dart                 # 应用入口
├── global.dart              # 全局初始化
├── common/                  # 公共模块
│   ├── api/                 # API 接口
│   ├── components/          # 公共组件
│   ├── extension/           # Dart 扩展
│   ├── i18n/                # 国际化
│   ├── middlewares/         # 路由中间件
│   ├── models/              # 数据模型
│   ├── routers/             # 路由配置
│   ├── services/            # 服务层
│   ├── store/               # 状态存储
│   ├── style/               # 样式主题
│   ├── utils/               # 工具类
│   ├── values/              # 常量值
│   └── widgets/             # 公共组件
└── pages/                   # 页面模块
    ├── welcome/             # 欢迎页
    ├── sign_in/             # 登录页
    ├── sign_up/             # 注册页
    ├── application/         # 主应用页
    ├── main/                # 主页
    └── about/               # 关于页
```

### 关键设计模式

#### 依赖注入 (GetX)
- 使用 `Get.put()` 全局注册服务
- 使用 `Get.find()` 获取服务实例
- 页面绑定（Bindings）自动管理控制器生命周期

#### 响应式编程
- 使用 `Rx` 可观察变量（如 `final _isLogin = false.obs`）
- 通过 `.value` 访问值，自动触发 UI 更新
- 使用 `Obx()` 或 `GetX` 组件包装响应式 UI

#### 错误处理
- HTTP 错误统一在 `HttpUtil` 中处理
- 使用 `EasyLoading` 显示错误提示
- 错误码映射到用户友好消息

### 开发约定

1. **新页面创建**:
   - 使用 `lib/pages` 下的现有页面作为模板
   - 确保在 `pages.dart` 中注册路由
   - 添加对应的路由名称到 `names.dart`

2. **API 接口添加**:
   - 在 `lib/common/api/` 下创建新的 API 类
   - 使用 `HttpUtil()` 发起请求
   - 返回对应的模型实体类

3. **状态管理**:
   - 页面级状态使用页面内的 `controller` 和 `state`
   - 全局状态使用 `Store` 类（UserStore、ConfigStore）
   - 避免在 Widget 中直接管理复杂状态

4. **代码风格**:
   - 遵循 Dart 官方代码风格指南
   - 使用 `flutter analyze` 检查代码质量
   - 重要逻辑添加注释说明

### 环境配置

- **Flutter SDK**: ^3.9.2
- **Dart SDK**: ^3.9.2
- **主要依赖**:
  - `get`: ^4.7.2 - GetX 状态管理、路由、依赖注入
  - `dio`: ^5.9.0 - HTTP 客户端
  - `flutter_screenutil`: ^5.9.3 - 屏幕适配
  - `flutter_easyloading`: ^3.0.5 - 加载提示
  - `shared_preferences`: ^2.5.3 - 本地存储

### 调试技巧

1. **GetX 调试**:
   ```dart
   // 查看当前注册的所有实例
   print(GetInstance().getAll());
   
   // 查看当前路由堆栈
   print(Get.routing.route);
   ```

2. **网络请求调试**:
   - 修改 `HttpUtil` 中的 `baseUrl`
   - 查看 Dio 拦截器日志
   - 使用 Postman 测试 API 接口

3. **状态监控**:
   - 使用 `Obx(() => Text('${controller.value}'))` 观察状态变化
   - 在控制器的 `onInit` 和 `onClose` 中添加日志
