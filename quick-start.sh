#!/bin/bash

# WindChaser 项目快速启动脚本

set -e

echo "🚀 WindChaser 项目快速启动"
echo "=========================="
echo ""

# 检查 Java 版本
echo "📋 检查环境..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    echo "✅ Java 版本: $(java -version 2>&1 | head -n 1)"
    if [ "$JAVA_VERSION" -lt 17 ]; then
        echo "⚠️  警告: 需要 JDK 17 或更高版本"
    fi
else
    echo "❌ 未找到 Java，请安装 JDK 17+"
    exit 1
fi

# Android 项目设置
echo ""
echo "📱 设置 Android 项目..."
cd android

# 检查 gradlew
if [ ! -f "gradlew" ]; then
    echo "❌ 未找到 gradlew，请先运行 fix-wrapper.sh"
    exit 1
fi

# 修复 wrapper
if [ -f "fix-wrapper.sh" ]; then
    echo "🔧 修复 Gradle Wrapper..."
    ./fix-wrapper.sh
fi

# 清理构建
echo "🧹 清理旧的构建..."
./gradlew clean

echo "✅ Android 项目准备就绪！"
echo "   提示: 运行 './gradlew build' 构建项目"
echo ""

# iOS 项目设置
echo "📱 设置 iOS 项目..."
cd ../ios

# 检查 CocoaPods
if ! command -v pod &> /dev/null; then
    echo "⚠️  未找到 CocoaPods"
    echo "   请运行: brew install cocoapods"
    echo "   然后运行: cd ios && pod install"
else
    echo "✅ CocoaPods 已安装: $(pod --version)"

    # 检查 Pods
    if [ ! -d "Pods" ]; then
        echo "📦 安装 iOS 依赖..."
        pod install
    else
        echo "✅ iOS 依赖已安装"
    fi

    echo "✅ iOS 项目准备就绪！"
    echo "   提示: 运行 'open RunningOS.xcworkspace' 打开 Xcode"
fi

echo ""
echo "🎉 项目设置完成！"
echo ""
echo "下一步："
echo "1. 申请高德地图 API Key: https://console.amap.com/dev/key/app"
echo "2. 配置 API Key 到项目中"
echo "3. 开始开发！"
echo ""
echo "详细文档: BUILD_FIXES.md"
