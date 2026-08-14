plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.culturaclub.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.culturaclub.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Nombre por defecto si compilaras sin flavor
        resValue("string", "app_name", "Cultura Club")
    }

    buildFeatures {
        // Obligatorio para que resValue funcione en Kotlin DSL
        resValues = true
    }

    flavorDimensions += "club"

    productFlavors {
        create("independiente") {
            dimension = "club"
            // Bundle ID real para las tiendas
            applicationId = "com.culturaclub.independiente"
            // Nombre inyectado en el launcher del teléfono
            resValue("string", "app_name", "Cultura CAI")
        }
        
        // Plantilla para un futuro club (descomentar y usar cuando sea necesario)
        /*
        create("racing") {
            dimension = "club"
            applicationId = "com.culturaclub.racing"
            resValue("string", "app_name", "Cultura Racing")
        }
        */
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}