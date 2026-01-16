import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key.properties if exists (for local builds)
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
}

android {
    namespace = "com.school.finder"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // Signing configuration for release builds
    signingConfigs {
        create("release") {
            // Environment variables (GitHub Actions) > key.properties (local)
            storeFile = file(System.getenv("KEYSTORE_PATH") ?: keyProperties.getProperty("storeFile") ?: "../keystore/release.keystore")
            storePassword = System.getenv("KEYSTORE_PASSWORD") ?: keyProperties.getProperty("storePassword") ?: ""
            keyAlias = System.getenv("KEY_ALIAS") ?: keyProperties.getProperty("keyAlias") ?: "release"
            keyPassword = System.getenv("KEY_PASSWORD") ?: keyProperties.getProperty("keyPassword") ?: ""
        }
    }

    defaultConfig {
        applicationId = "com.school.finder"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar", "*.aar"))))
}
