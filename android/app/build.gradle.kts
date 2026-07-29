import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.omegapi.newsapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.omegapi.newsapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["admobAppId"] = "ca-app-pub-3940256099942544~3347511713" // Default test ID
    }

    flavorDimensions += "mode"

    productFlavors {
        create("us") {
            dimension = "mode"
            applicationId = "com.omegapi.newsapp.us"
            resValue("string", "app_name", "News US")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-2321249943983804~2884996867"
        }
        create("uk") {
            dimension = "mode"
            applicationId = "com.omegapi.newsapp.uk"
            resValue("string", "app_name", "News UK")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-2321249943983804~2950012835"
        }
        create("de") {
            dimension = "mode"
            applicationId = "com.omegapi.newsapp.de"
            resValue("string", "app_name", "Nachrichten DE")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-2321249943983804~7098425260"
        }
        create("au") {
            dimension = "mode"
            applicationId = "com.omegapi.newsapp.au"
            resValue("string", "app_name", "News AU")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-2321249943983804~9928758267"
        }
        create("fr") {
            dimension = "mode"
            applicationId = "com.omegapi.newsapp.fr"
            resValue("string", "app_name", "Nouvelles FR")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-2321249943983804~2041539703"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
