#!/bin/bash

# iOS 项目运行脚本

WORKSPACE="RunningOS.xcworkspace"
SCHEME="RunningOS"

echo "📱 RunningOS iOS 项目运行脚本"
echo "================================"

# 检查 workspace 是否存在
if [ ! -f "$WORKSPACE" ]; then
    echo "❌ 找不到 $WORKSPACE"
    echo "请先运行 pod install"
    exit 1
fi

# 列出可用的模拟器
echo ""
echo "📋 可用的 iPhone 模拟器："
xcrun simctl list devices available | grep "iPhone" | grep -v "iPhone 6" | grep -v "iPhone 7" | grep -v "iPhone 8" | head -15

echo ""
echo "💡 使用方法："
echo "1. 在 Xcode 中打开此项目"
echo "2. 点击顶部的设备选择器"
echo "3. 选择一个 iPhone 模拟器"
echo "4. 按 Cmd+R 运行"
echo ""
echo "或者从命令行运行："
echo "xcodebuild -workspace $WORKSPACE -scheme $SCHEME -destination 'platform=iOS Simulator,name=iPhone 15 Pro'"
echo ""

# 直接在 Xcode 中打开
echo "🚀 在 Xcode 中打开项目..."
open "$WORKSPACE"
