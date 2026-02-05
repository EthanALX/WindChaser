# 高德地图 API Key 配置指南

## 📝 重要提示

当前 `AppDelegate.swift` 中的 API Key 为空字符串，应用可以运行但地图无法显示。

## 🔑 获取 API Key

1. **访问高德开放平台**
   https://console.amap.com/dev/key/app

2. **注册/登录账号**
   - 使用手机号注册
   - 或使用第三方账号登录

3. **创建应用**
   - 点击「创建新应用」
   - 应用名称：`RunningOS`
   - 应用类型：选择「移动端」

4. **添加 Key**
   - 点击「添加 Key」按钮
   - 平台：选择「iOS 平台」
   - Bundle ID：输入 `com.windchaser.RunningOS`
   - 输入 SHA1 码（调试阶段可选）
   - 点击「提交」

5. **复制 Key**
   - 获得类似：`a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`

## ⚙️ 配置到项目

### 方法 1：直接修改 AppDelegate.swift（推荐用于测试）

打开 `/Users/alisa/Coding/wind/ios/AppDelegate.swift`，修改第 14 行：

```swift
AMapServices.shared().apiKey = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
```

### 方法 2：使用环境变量（推荐用于生产）

1. 在 Xcode 中配置：
   - 点击项目导航器中的 `RunningOS` 项目
   - 选择 `RunningOS` target
   - 点击 `Build Settings` 标签
   - 搜索 `Swift Compiler - Custom Flags`
   - 在 `Other Swift Flags` 的 Debug 栏添加：
     ```
     -DAMAP_API_KEY="\"你的API_KEY\""
     ```

2. 修改 `AppDelegate.swift`：

```swift
AMapServices.shared().apiKey = Bundle.main.object(forInfoDictionaryKey: "AMapApiKey") as? String ?? ""
```

3. 在 `Info.plist` 中添加：

```xml
<key>AMapApiKey</key>
<string>你的API_KEY</string>
```

### 方法 3：使用 .xcconfig 文件（推荐用于团队协作）

1. 创建 `ios/Config.xcconfig`：

```
AMAP_API_KEY = a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

2. 在 Xcode 中配置：
   - 选择项目 -> Info -> Configurations
   - Debug 和 Release 都选择 `Config`

3. 在 `AppDelegate.swift` 中使用：

```swift
#if AMAP_API_KEY
let apiKey = "\(AMAP_API_KEY)"
#else
let apiKey = ""
#endif

AMapServices.shared().apiKey = apiKey
```

## ✅ 验证配置

配置完成后，重新运行应用：

1. 在 Xcode 中按 `Cmd+R` 运行
2. 应用启动后应该能看到地图显示
3. 如果地图显示空白，检查：
   - API Key 是否正确
   - Bundle ID 是否匹配
   - 网络连接是否正常

## 🐛 调试技巧

### 启用高德地图日志

在 `AppDelegate.swift` 中已添加：

```swift
#if DEBUG
AMapServices.shared().enableHTTPS = true
#endif
```

查看控制台日志，搜索 `AMap` 关键字。

### 常见错误

1. **错误 1008：Key 不存在或过期**
   - 检查 API Key 是否正确复制
   - 确认 Key 在控制台中处于「启用」状态

2. **错误 1009：Key 鉴权失败**
   - 检查 Bundle ID 是否匹配
   - 确认应用类型选择正确（iOS 平台）

3. **地图显示空白**
   - 检查网络连接
   - 确认位置权限已开启
   - 查看 Xcode 控制台错误信息

## 📞 获取帮助

- 高德地图 iOS SDK 文档：https://lbs.amap.com/api/ios-sdk/summary/
- 高德开放平台控制台：https://console.amap.com/
- 技术支持社区：https://lbs.amap.com/faq/

---

**注意**：暂时不配置 API Key 也可以运行应用，但地图功能将无法正常显示。建议尽快完成配置以测试完整功能。
