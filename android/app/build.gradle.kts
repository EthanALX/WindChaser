plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.dagger.hilt.android")
    id("com.google.devtools.ksp")
    kotlin("kapt")
}

android {
    namespace = "com.windchaser.runningos"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.windchaser.runningos"
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.14"
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    java {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(17))
        }
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            // Exclude duplicate native libraries from Amap SDK
            excludes += "/lib/**"
            excludes += "**/*.so"
            excludes += "**/*.a"
        }
        jniLibs {
            useLegacyPackaging = true
        }
    }
}

configurations.all {
    resolutionStrategy {
        // Force usage of classes from search library to avoid duplicates
        force("com.amap.api:search:6.1.0")
    }
}

// Workaround for KSP issue with large native libraries in Amap SDK
// The Amap SDK contains large .so files that cause KSP to fail with FileTooBigException
// KSP tries to process all JARs on classpath, including native libraries
// Solution: Exclude Amap SDK from annotation processor classpath

// Note: Using kapt instead of ksp for Hilt and Room to avoid FileTooBigException with Amap SDK's native libraries
// KSP scans all JARs on compile classpath including embedded .so files, while kapt doesn't have this issue
// This is a known limitation of KSP when dealing with libraries containing large native resources

dependencies {
    // Core Compose
    implementation(platform("androidx.compose:compose-bom:2024.06.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.activity:activity-compose:1.9.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.8.2")

    // Hilt Dependency Injection
    implementation("com.google.dagger:hilt-android:2.51.1")
    kapt("com.google.dagger:hilt-compiler:2.51.1")
    implementation("androidx.hilt:hilt-navigation-compose:1.2.0")

    // Room Database
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    kapt("androidx.room:room-compiler:2.6.1")

    // Retrofit & Networking
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")

    // Coroutines & Flow
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.2")

    // 高德地图 SDK (替换 Mapbox)
    // 3D地图 SDK 已包含定位和搜索功能
    implementation("com.amap.api:3dmap-location-search:latest.integration")

    // Image Loading
    implementation("io.coil-kt:coil-compose:2.6.0")

    // Navigation
    implementation("androidx.navigation:navigation-compose:2.7.7")

    debugImplementation("androidx.compose.ui:ui-tooling")
}
