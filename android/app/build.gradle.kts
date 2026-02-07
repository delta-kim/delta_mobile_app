import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    //id("com.mob.sdk")
    //id("cn.fly.sdk")
}

// 加载本地属性
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

// 加载签名配置（如果需要）
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "kim.delta.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion //"27.0.12077973" 

    // packaging {
    //     jniLibs {
    //         useLegacyPackaging = false
    //         keepDebugSymbols.add("**/*.so")
    //     }
    // }

    // buildTypes {
    //     getByName("release") {
    //         isMinifyEnabled = false
    //         isShrinkResources = false
    //         ndk {
    //             debugSymbolLevel = "none"
    //         }
    //     }
    // }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // flutter_local_notifications 插件 脱糖用
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "kim.delta.mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24 //flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        // ndk  {
        //     abiFilters += listOf("armeabi-v7a", "arm64-v8a") // 只保留需要的 ABI x86_64
        // }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias") as String
            keyPassword = keystoreProperties.getProperty("keyPassword") as String
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword") as String
        }
    }

    buildTypes {
        getByName("release") {  // 使用 getByName() 访问 buildType
            isMinifyEnabled = true  // Kotlin DSL 使用 isMinifyEnabled
            isShrinkResources = true  // Kotlin DSL 使用 isShrinkResources
            signingConfig = signingConfigs.getByName("release")  // 使用 getByName()
            //signingConfig = signingConfigs.getByName("debug")  // 使用 getByName()
            
            // 如果需要配置 ProGuard
             proguardFiles(
                 getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
             )
        }
    }
}

flutter {
    source = "../.."

    // 通过 afterEvaluate 配置入口点


    // val main = extra["main"] as groovy.lang.Closure<*>
    // val secondary = extra["secondary"] as groovy.lang.Closure<*>
    // with(extra) {
    //     set("main", main.apply {
    //         setProperty("entryPoint", "main")
    //     })
    //     set("secondary", secondary.apply {
    //         setProperty("entryPoint", "secondaryMain")
    //     })
    // }
    
}
    // project.afterEvaluate {
    //     extensions.configure<FlutterExtension> {
    //         setProperty("entryPoint", "main")
    //         setProperty("entryPoint", "secondaryMain")
    //         // 多入口点需要更复杂的配置
    //     }
    // }


dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // flutter_local_notifications 插件 脱糖用
    implementation("com.google.code.gson:gson:2.10.1")
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))

  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
    implementation("com.google.firebase:firebase-analytics")
}

// FlySDK {
//     appKey = "3bdc0380c306b"
//     appSecret = "5634956101fa202a112fa9215a61a5ef"
//     MobPush {
//          MobPush {
//             FCM {
//                 iconRes "@mipmap/default_ic_launcher"
//             }
//          }
//     }
// }

