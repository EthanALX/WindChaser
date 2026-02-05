# WindChaser 项目构建修复总结

## ✅ 已自动修复的问题

### Android 项目
1. **生成 Gradle Wrapper** - 创建了 `gradlew` 脚本文件
2. **清理 Mapbox 配置** - 移除了 settings.gradle.kts 中的 Mapbox Maven 仓库
3. **清理 Gradle Properties** - 移除了 MAPBOX_DOWNLOADS_TOKEN
4. **删除重复文件** - 删除了根目录下重复的 Theme.kt
5. **添加配置说明** - 在 AndroidManifest.xml 中添加了 API Key 配置注释

### iOS 项目
1. **修复 Info.plist** - 移除了 MBXAccessToken Mapbox 配置
2. **修复 DIContainer** - 添加了无参数的 `resolve()` 方法
3. **添加缺失组件** - 实现了 HeatmapCard 组件

## ⚠️ 需要手动执行的步骤

### 步骤 1: 修复 Android Gradle Wrapper

由于 Gradle Wrapper jar 文件下载问题，需要手动修复：

```bash
cd android

# 方法 1: 运行修复脚本 (推荐)
./fix-wrapper.sh

# 方法 2: 使用系统的 gradle
gradle wrapper --gradle-version 8.6

# 方法 3: 在 Android Studio 中打开项目
# Android Studio 会自动检测并修复 wrapper
```

### 步骤 2: 安装 CocoaPods

```bash
# 安装 CocoaPods
brew install cocoapods

# 或者使用 gem
sudo gem install cocoapods
```

### 步骤 3: 安装 iOS 依赖

```bash
cd ios
pod install
```

### 步骤 4: 配置高德地图 API Key

#### Android
编辑 `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.amap.api.v2.apikey"
    android:value="你的实际API密钥" />
```

#### iOS
需要创建 `AppDelegate.swift`:

```swift
import UIKit
import AMapFoundationKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 配置高德地图 API Key
        AMapServices.shared().apiKey = "你的实际API密钥"
        return true
    }
}
```

并修改 `RunningOSApp.swift`:

```swift
import SwiftUI

@main
struct RunningOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
```

### 步骤 5: 构建项目

#### Android
```bash
cd android
./gradlew clean build
# 或使用 Android Studio 打开项目
```

#### iOS
```bash
cd ios
open RunningOS.xcworkspace
# 在 Xcode 中构建和运行
```

## 🔧 项目结构

```
wind/
├── android/                     # Android 原生项目
│   ├── app/
│   │   └── src/main/
│   │       ├── java/com/windchaser/runningos/
│   │       │   ├── data/       # 数据层 (Repository, Database)
│   │       │   ├── domain/     # 领域层 (Models, UseCases)
│   │       │   ├── ui/         # UI 层 (Screens, Components)
│   │       │   ├── di/         # 依赖注入 (Hilt Modules)
│   │       │   ├── MainActivity.kt
│   │       │   └── RunningOSApplication.kt
│   │       └── AndroidManifest.xml
│   ├── build.gradle.kts
│   ├── settings.gradle.kts
│   ├── gradlew                 # Gradle Wrapper 脚本
│   └── fix-wrapper.sh          # Wrapper 修复脚本
├── ios/                        # iOS 原生项目
│   ├── RunningOS.xcodeproj/
│   ├── Core/                   # 核心组件
│   │   ├── DI/DIContainer.swift
│   │   └── Theme/Theme.swift
│   ├── Data/                   # 数据层
│   │   └── Repositories/
│   ├── Domain/                 # 领域层
│   │   ├── Models/
│   │   ├── Repositories/
│   │   └── UseCases/
│   ├── Features/               # 功能模块
│   │   └── Home/
│   │       ├── ViewModels/
│   │       └── Views/
│   ├── Shared/                 # 共享组件
│   │   └── Views/CommonComponents.swift
│   ├── Podfile
│   ├── Info.plist
│   └── RunningOSApp.swift
└── design/                     # 设计资源
```

## 📋 技术栈总结

| 层级 | Android | iOS |
|------|---------|-----|
| **UI 框架** | Jetpack Compose + Material3 | SwiftUI |
| **架构模式** | MVVM + Clean Architecture | MVVM + Clean Architecture |
| **依赖注入** | Hilt | 自定义 DI Container |
| **数据库** | Room | (待实现) |
| **网络** | Retrofit + OkHttp | URLSession |
| **异步处理** | Coroutines + Flow | Combine |
| **地图 SDK** | 高德地图 Android SDK | 高德地图 iOS SDK |

## 🚀 快速启动指南

### 前置要求

- **JDK 17+** (Android)
- **Android Studio Hedgehog | 2023.1.1+** (推荐)
- **Xcode 15.0+** (iOS)
- **CocoaPods** (iOS)
- **Gradle 8.6** (Android，可自动下载)

### 开发环境设置

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd wind
   ```

2. **配置 Android**
   ```bash
   cd android
   ./fix-wrapper.sh          # 修复 Gradle Wrapper
   ./gradlew build          # 构建项目
   ```

3. **配置 iOS**
   ```bash
   brew install cocoapods    # 安装 CocoaPods
   cd ../ios
   pod install              # 安装依赖
   open RunningOS.xcworkspace  # 打开 Xcode
   ```

4. **申请 API Key**
   - 访问: https://console.amap.com/dev/key/app
   - 创建应用并获取 API Key
   - 按照步骤 4 配置到项目中

## 🔍 常见问题排查

### Android 构建失败

**问题**: `Could not find or load main class GradleWrapperMain`
**解决**: 运行 `./fix-wrapper.sh` 修复 wrapper

**问题**: 依赖冲突
**解决**:
```bash
./gradlew clean
./gradlew build --refresh-dependencies
```

### iOS 构建失败

**问题**: `pod: command not found`
**解决**: `brew install cocoapods`

**问题**: CocoaPods 依赖安装失败
**解决**:
```bash
pod deintegrate
pod install
```

**问题**: 缺少 AMap SDK
**解决**: 确保运行了 `pod install`

### 地图显示问题

**问题**: 地图不显示或显示空白
**解决**:
1. 检查 API Key 是否正确配置
2. 检查网络权限
3. Android: 检查 AndroidManifest.xml 中的权限配置
4. iOS: 检查 Info.plist 中的位置权限

## 📝 后续改进建议

1. **数据持久化**
   - iOS: 添加 Core Data 或 Realm 实现
   - Android: 完善 Room 数据库配置

2. **测试覆盖**
   - 添加单元测试 (JUnit, XCTest)
   - 添加 UI 测试 (Compose Testing, XCUITest)

3. **CI/CD 配置**
   - GitHub Actions 工作流
   - 自动化测试和部署

4. **代码质量**
   - 添加代码检查工具 (ktlint, SwiftLint)
   - 配置代码格式化规则

## 📞 获取帮助

如果遇到问题：
1. 查看 `BUILD_FIXES.md` 获取详细的修复步骤
2. 检查项目的 GitHub Issues
3. 查阅高德地图官方文档: https://lbs.amap.com/

## 🎉 开始开发

修复完所有问题后，你就可以开始开发了：
- **Android**: 在 Android Studio 中打开 `android` 目录
- **iOS**: 在 Xcode 中打开 `ios/RunningOS.xcworkspace`

祝你开发愉快！🚀
