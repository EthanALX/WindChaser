#!/bin/bash

echo "🚀 在 iPhone 15 Pro 模拟器上运行 RunningOS..."

xcodebuild -workspace RunningOS.xcworkspace \
  -scheme RunningOS \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  build

if [ $? -eq 0 ]; then
    echo "✅ 构建成功！启动应用..."
    xcrun simctl launch "iPhone 15 Pro" com.windchaser.RunningOS 2>/dev/null || \
    echo "💡 请在 Xcode 中按 Cmd+R 运行应用"
else
    echo "❌ 构建失败，请检查错误信息"
fi
