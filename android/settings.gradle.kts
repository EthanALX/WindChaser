pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.aliyun.com/repository/public")
        }
        maven {
            url = uri("https://jitpack.io")
        }
        // 高德地图 Maven 仓库
        maven {
            url = uri("https://maven.aliyun.com/repository/releases")
        }
    }
}

rootProject.name = "RunningOS"
include(":app")
