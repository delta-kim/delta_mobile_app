// buildscript {
//     repositories {
//         google()
//         mavenCentral()
//         // 添加 Mob SDK 的特定仓库
//         maven { url = uri("https://mvn.zztfly.com/android") }
//     }
//     dependencies { // 这个 dependencies 块必须在 buildscript 内
//         //classpath("com.android.tools.build:gradle:3.2.1")
//         //classpath("com.mob.sdk:MobSDK:+")
//         classpath("cn.fly.sdk:FlySDK:+")
//         //classpath("com.google.gms:google-services:4.4.3")
//     }
// }
allprojects {
    repositories {
        google()
        mavenCentral()
        // maven { url = uri("https://mvn.zztfly.com/android") }
    }

}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// plugins {
//     id("com.google.gms.google-services") version "4.4.3" apply false
// }
