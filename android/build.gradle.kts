plugins {
    id("com.android.application") version "8.7.3" apply false   // match Flutter
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false  // match Flutter
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirect build outputs
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
