allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 👇 MOVED UP: This forces the plugins to use Android SDK 36.
subprojects {
    afterEvaluate {
        extensions.findByName("android")?.let { ext ->
            (ext as? com.android.build.gradle.BaseExtension)?.apply {
                compileSdkVersion(36)

                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}