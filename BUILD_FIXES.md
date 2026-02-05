# 构建修复说明

## 已修复的问题

### Android 项目
1. ✅ 生成了缺失的 `gradlew` 文件
2. ✅ 清理了 settings.gradle.kts 中的 Mapbox Maven 仓库配置
3. ✅ 移除了 gradle.properties 中的 MAPBOX_DOWNLOADS_TOKEN
4. ✅ 删除了重复的 Theme.kt 文件
5. ✅ 添加了 API Key 配置说明

### iOS 项目
1. ✅ 修复了 Info.plist 中的 Mapbox 配置残留
2. ✅ 修复了 DIContainer.swift 中的 resolve 方法
3. ✅ 添加了缺失的 HeatmapCard 组件

## 需要手动配置的步骤

### 1. 安装 CocoaPods (iOS 依赖管理)

```bash
# 方式 1: 使用 Homebrew (推荐)
brew install cocoapods

# 方式 2: 使用 gem
sudo gem install cocoapods

# 方式 3: 使用 bundler
# 创建 Gemfile:
echo "gem 'cocoapods', '~> 1.14'" > Gemfile
bundle install
```

### 2. 安装 iOS 依赖

```bash
cd ios
pod install
```

### 3. 配置高德地图 API Key

#### Android
在 `android/app/src/main/AndroidManifest.xml` 中替换 `YOUR_AMAP_API_KEY`:

```xml
<meta-data
    android:name="com.amap.api.v2.apikey"
    android:value="YOUR_ACTUAL_AMAP_API_KEY" />
```

#### iOS
在 `ios/RunningOSApp.swift` 或创建的 `AppDelegate.swift` 中设置:

```swift
import AMapFoundationKit

// 在应用启动时
AMapServices.shared().apiKey = "YOUR_ACTUAL_AMAP_API_KEY"
```

### 4. 构建项目

#### Android
```bash
cd android
./gradlew clean
./gradlew build
# 或在 Android Studio 中打开项目
```

#### iOS
```bash
# 确保已安装 CocoaPods 依赖
cd ios
pod install

# 然后使用 Xcode 打开
open RunningOS.xcworkspace
```

## 项目结构

```
wind/
├── android/           # Android 原生项目 (Kotlin + Jetpack Compose)
│   ├── app/
│   │   └── src/main/java/com/windchaser/runningos/
│   │       ├── data/      # 数据层
│   │       ├── domain/    # 领域层
│   │       ├── ui/        # UI 层
│   │       └── di/        # 依赖注入
│   └── gradlew           # Gradle Wrapper (新生成)
├── ios/               # iOS 原生项目 (Swift + SwiftUI)
│   ├── RunningOS.xcodeproj/
│   ├── Core/            # 核心组件 (DI, Theme)
│   ├── Data/            # 数据层
│   ├── Domain/          # 领域层
│   ├── Features/        # 功能模块
│   └── Shared/          # 共享组件
└── design/             # 设计资源
```

## 技术栈

### Android
- **UI 框架**: Jetpack Compose + Material3
- **架构**: MVVM + Clean Architecture
- **依赖注入**: Hilt
- **数据库**: Room
- **网络**: Retrofit + OkHttp
- **地图**: 高德地图 SDK
- **异步**: Coroutines + Flow

### iOS
- **UI 框架**: SwiftUI
- **架构**: MVVM + Clean Architecture
- **依赖注入**: 自定义 DI Container
- **响应式**: Combine
- **地图**: 高德地图 SDK (AMapFoundationKit, MAMapKit)

## API Key 申请

高德地图 API Key 申请地址: https://console.amap.com/dev/key/app

申请时需要:
1. 应用名称 (RunningOS)
2. 应用包名 (Android: com.windchaser.runningos)
3. Bundle ID (iOS: 需要在 Xcode 中配置)
4. SHA1 签名 (Android 需要发布版和调试版)

## 常见问题

### Android 构建失败
- 检查 JDK 版本 (需要 JDK 17)
- 检查 Android SDK 是否安装完整
- 清理构建缓存: `./gradlew clean`

### iOS 构建失败
- 确保 CocoaPods 已安装: `pod --version`
- 清理构建缓存: 在 Xcode 中 Product > Clean Build Folder
- 检查 iOS 部署目标版本 (最低 iOS 15.0)

### 地图显示问题
- 确认 API Key 已正确配置
- 检查网络权限配置
- Android: 检查 AndroidManifest.xml 中的权限
- iOS: 检查 Info.plist 中的位置权限
