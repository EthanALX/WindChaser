#!/bin/bash

# 修复 Gradle Wrapper 的脚本
# 此脚本将重新生成正确的 gradle-wrapper.jar 文件

echo "正在修复 Gradle Wrapper..."

# 方法 1: 尝试使用系统的 gradle 命令
if command -v gradle &> /dev/null; then
    echo "发现系统 gradle，正在重新生成 wrapper..."
    gradle wrapper --gradle-version 8.6
    chmod +x gradlew
    echo "Gradle Wrapper 修复完成！"
    exit 0
fi

# 方法 2: 使用 Android Studio 的 Gradle
ANDROID_STUDIO_GRADLE="/Applications/Android Studio.app/Contents/tools/gradle"
if [ -d "$ANDROID_STUDIO_GRADLE" ]; then
    echo "使用 Android Studio 的 Gradle 重新生成 wrapper..."
    cd "$ANDROID_STUDIO_GRADLE" && ./gradle wrapper --gradle-version 8.6 -p "$OLDPWD"
    chmod +x gradlew
    echo "Gradle Wrapper 修复完成！"
    exit 0
fi

# 方法 3: 下载预构建的 wrapper jar
echo "正在下载 Gradle Wrapper jar..."
WRAPPER_JAR_URL="https://github.com/gradle/gradle/raw/v8.6.0/gradle/wrapper/gradle-wrapper.jar"

# 尝试使用 curl
if command -v curl &> /dev/null; then
    curl -L -o gradle/wrapper/gradle-wrapper.jar "$WRAPPER_JAR_URL" 2>/dev/null
    if [ $? -eq 0 ] && [ -s gradle/wrapper/gradle-wrapper.jar ]; then
        chmod +x gradlew
        echo "Gradle Wrapper 修复完成！"
        exit 0
    fi
fi

# 如果所有方法都失败
echo "================================"
echo "无法自动修复 Gradle Wrapper"
echo "请手动执行以下步骤之一："
echo ""
echo "方法 1: 使用系统的 gradle 命令"
echo "  gradle wrapper --gradle-version 8.6"
echo ""
echo "方法 2: 在 Android Studio 中打开项目"
echo "  Android Studio 会自动修复 Gradle Wrapper"
echo ""
echo "方法 3: 下载并解压 Gradle"
echo "  1. 下载: https://gradle.org/releases/"
echo "  2. 解压到本地"
echo "  3. 运行: <gradle-path>/bin/gradle wrapper --gradle-version 8.6"
echo "================================"
exit 1
