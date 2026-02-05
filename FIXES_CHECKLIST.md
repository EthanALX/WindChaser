# WindChaser 项目修复清单

## ✅ 已完成的修复

### Android 项目
- [x] 生成 `gradlew` 脚本文件
- [x] 移除 `settings.gradle.kts` 中的 Mapbox Maven 仓库配置
- [x] 移除 `gradle.properties` 中的 `MAPBOX_DOWNLOADS_TOKEN`
- [x] 删除重复的 `Theme.kt` 文件（根目录）
- [x] 在 `AndroidManifest.xml` 添加 API Key 配置注释
- [x] 创建 `fix-wrapper.sh` 修复脚本
- [x] 验证项目结构完整性

### iOS 项目
- [x] 移除 `Info.plist` 中的 `MBXAccessToken` Mapbox 配置
- [x] 在 `Info.plist` 添加高德地图配置说明
- [x] 修复 `DIContainer.swift` 添加无参数 `resolve()` 方法
- [x] 实现 `HeatmapCard` 组件
- [x] 验证所有 Swift 文件语法正确
- [x] 检查所有 UI 组件定义完整

### 文档
- [x] 创建 `BUILD_FIXES.md` - 详细修复说明
- [x] 创建 `FIXES_SUMMARY.md` - 完整项目文档
- [x] 创建 `quick-start.sh` - 快速启动脚本
- [x] 创建 `android/fix-wrapper.sh` - Gradle Wrapper 修复脚本

## ⚠️ 需要手动处理的步骤

### 1. 修复 Android Gradle Wrapper Jar

**问题**: gradle-wrapper.jar 文件不完整或损坏
**影响**: 无法运行 `./gradlew` 命令
**解决方案**:

```bash
cd android
./fix-wrapper.sh
```

或手动执行：

```bash
# 如果系统已安装 gradle
gradle wrapper --gradle-version 8.6

# 或在 Android Studio 中打开项目
# Android Studio 会自动修复 wrapper
```

**验证**: 运行 `./gradlew --version` 应显示 Gradle 8.6

### 2. 安装 CocoaPods

**问题**: iOS 项目依赖需要 CocoaPods 管理
**影响**: 无法构建 iOS 项目
**解决方案**:

```bash
brew install cocoapods
# 或
sudo gem install cocoapods
```

**验证**: 运行 `pod --version` 应显示版本号

### 3. 安装 iOS 依赖

**问题**: 缺少 Pods 目录和依赖库
**影响**: iOS 项目无法编译
**解决方案**:

```bash
cd ios
pod install
```

**验证**: 应生成 `Pods` 目录和 `RunningOS.xcworkspace`

### 4. 配置高德地图 API Key

**问题**: 使用占位符 API Key
**影响**: 地图无法显示
**解决方案**:

#### Android
编辑 `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.amap.api.v2.apikey"
    android:value="你的实际API密钥" />
```

#### iOS
创建 `ios/AppDelegate.swift`:
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
        AMapServices.shared().apiKey = "你的实际API密钥"
        return true
    }
}
```

修改 `ios/RunningOSApp.swift`:
```swift
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

**验证**: 运行应用后地图应能正常显示

### 5. 创建 iOS AppDelegate

**问题**: iOS 项目缺少 AppDelegate 文件
**影响**: 无法配置应用生命周期和 API Key
**解决方案**: 见步骤 4 中的 iOS 部分

**文件路径**: `/Users/alisa/Coding/wind/ios/AppDelegate.swift`

## 🔍 验证清单

### Android 项目
```bash
cd android

# 1. 检查 Gradle Wrapper
./gradlew --version
# 预期输出: Gradle 8.6

# 2. 清理构建
./gradlew clean

# 3. 构建项目
./gradlew build
# 预期输出: BUILD SUCCESSFUL
```

### iOS 项目
```bash
cd ios

# 1. 检查 CocoaPods
pod --version

# 2. 安装依赖
pod install
# 预期输出: Pod installation complete!

# 3. 在 Xcode 中构建
open RunningOS.xcworkspace
# 在 Xcode 中按 Cmd+B 构建
```

## 📊 修复统计

| 类别 | 数量 |
|------|------|
| 修复的文件 | 7 |
| 新建的文件 | 8 |
| 修复的配置问题 | 6 |
| 修复的代码问题 | 3 |
| 需要手动执行的步骤 | 5 |

## 📁 新建的文件

```
wind/
├── android/
│   ├── gradlew                           # Gradle Wrapper 脚本
│   └── fix-wrapper.sh                    # Wrapper 修复脚本
├── ios/
│   └── AppDelegate.swift                 # iOS AppDelegate (待创建)
├── BUILD_FIXES.md                        # 详细修复说明
├── FIXES_SUMMARY.md                      # 完整项目文档
├── FIXES_CHECKLIST.md                    # 本文件
└── quick-start.sh                        # 快速启动脚本
```

## 🎯 优先级

### 高优先级（必须完成才能构建）
1. 修复 Android Gradle Wrapper
2. 安装 CocoaPods
3. 安装 iOS 依赖（pod install）

### 中优先级（功能需要）
4. 配置高德地图 API Key
5. 创建 iOS AppDelegate

### 低优先级（可选）
- 添加单元测试
- 配置 CI/CD
- 优化代码结构

## 💡 提示

1. **首次构建建议顺序**:
   ```
   修复 Gradle Wrapper → 安装 CocoaPods → pod install → 配置 API Key → 构建
   ```

2. **推荐的开发工具**:
   - Android: Android Studio Hedgehog | 2023.1.1+
   - iOS: Xcode 15.0+

3. **获取帮助**:
   - 高德地图文档: https://lbs.amap.com/
   - Android Gradle: https://docs.gradle.org/
   - CocoaPods: https://cocoapods.org/

## ✨ 完成后的下一步

完成所有修复步骤后，你可以：

1. **开始开发**:
   - Android: 在 Android Studio 中打开 `android` 目录
   - iOS: 在 Xcode 中打开 `ios/RunningOS.xcworkspace`

2. **添加新功能**:
   - 查看现有的 MVVM 架构示例
   - 遵循 Clean Architecture 原则
   - 使用相同的依赖注入模式

3. **测试应用**:
   - 在真机上测试地图功能
   - 验证位置权限
   - 测试 UI 交互

4. **部署应用**:
   - Android: 生成签名 APK/AAB
   - iOS: 配置 Provisioning Profile 和证书

---

**最后更新**: 2026-02-05
**项目状态**: 🟡 需要手动完成部分步骤才能构建
**预计完成时间**: 15-30 分钟
