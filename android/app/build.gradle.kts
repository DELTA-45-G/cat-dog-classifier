plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cat_dog_classifier"

    // 👇 UPDATE: Changed to 36 (Android 16 Preview) to satisfy plugin requirements
    compileSdk = 36
    
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.cat_dog_classifier"
        
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion

        // 👇 UPDATE: Changed to 36 to match compileSdk
        targetSdk = 36
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 👇 KEY FIX 1: Keeps the TFLite model from being compressed (Crucial for your app)
    aaptOptions {
        noCompress.addAll(listOf("tflite", "lite"))
    }

    buildTypes {
        release {
            // 👇 KEY FIX 2: Disables code shrinking to prevent "Missing Class" errors
            isMinifyEnabled = false
            isShrinkResources = false

            // Signing with the debug keys so you can share it immediately
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}