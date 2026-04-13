plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.fliq.fliq"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.fliq.fliq"
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ── Release imzalama ─────────────────────────────────────────────────────
    // android/key.properties dosyasını oluştur (git'e EKLEME, .gitignore'a ekle):
    //   storeFile=../keystore/fliq-release.jks
    //   storePassword=SIFREN
    //   keyAlias=fliq
    //   keyPassword=SIFREN
    val keyPropsFile = rootProject.file("key.properties")
    if (keyPropsFile.exists()) {
        val keyProps = java.util.Properties().apply { load(keyPropsFile.inputStream()) }
        signingConfigs {
            create("release") {
                keyAlias      = keyProps["keyAlias"]      as String
                keyPassword   = keyProps["keyPassword"]   as String
                storeFile     = file(keyProps["storeFile"] as String)
                storePassword = keyProps["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keyPropsFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
            isMinifyEnabled   = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
