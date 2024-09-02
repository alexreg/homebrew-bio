class Dedup < Formula
  desc "Merged-read deduplication tool"
  homepage "https://github.com/apeltzer/DeDup"
  url "https://github.com/apeltzer/DeDup/archive/refs/tags/0.12.8.tar.gz"
  sha256 "cfa1645631c90b74151df7cc08aaa0e28712b7e533616f19d9f18c89bc60b26c"
  license "GPL-3.0-or-later"
  head "https://github.com/apeltzer/DeDup.git", branch: "master"

  depends_on "gradle" => :build
  depends_on "openjdk@11" => :build

  patch :DATA

  def install
    system "gradle", "build"
    jar = "build/libs/DeDup-#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "DeDup", java_version: "11"
  end

  test do
    assert_match "DeDup v#{version}", shell_output("#{bin}/DeDup -h 2>&1")
  end
end
__END__
diff --git a/.gitignore b/.gitignore
index be0c9b8..73c1e3f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,4 +1,4 @@
-build/*
+build/
+gradle/
 .gradle/*
 .idea/*
-gradle/
\ No newline at end of file
diff --git a/build.gradle b/build.gradle
index 8c9aa93..0870ea6 100644
--- a/build.gradle
+++ b/build.gradle
@@ -6,12 +6,11 @@ apply plugin: 'idea'
 apply plugin: 'jacoco'
 
 
-sourceCompatibility = 1.8
-
 repositories {
     mavenCentral()
 }
 
+
 sourceSets {
     main {
         java {
@@ -27,51 +26,57 @@ sourceSets {
 
 
 dependencies {
-    compile 'org.apache.commons:commons-lang3:3.4'
-    compile group: 'commons-cli', name: 'commons-cli', version: '1.3.1'
-    compile 'org.hamcrest:hamcrest-core:1.3'
-    compile 'com.google.guava:guava:+'
-    compile 'com.github.samtools:htsjdk:+'
-    compile 'junit:junit:4.12'
-    compile 'com.google.code.gson:gson:2.8.5'
-    testCompile group: 'junit', name: 'junit', version: '4.12'
+    implementation 'org.apache.commons:commons-lang3:3.4'
+    implementation group: 'commons-cli', name: 'commons-cli', version: '1.3.1'
+    implementation 'org.hamcrest:hamcrest-core:1.3'
+    implementation 'com.google.guava:guava:+'
+    implementation 'com.github.samtools:htsjdk:3.0.5'
+    implementation 'junit:junit:4.12'
+    implementation 'com.google.code.gson:gson:2.8.5'
+    testImplementation group: 'junit', name: 'junit', version: '4.12'
+}
+
+
+java {
 }
 
+
 jar {
     manifest {
         attributes("Implementation-Title": "DeDup",
                 "Implementation-Version": version, "main-Class": "main.java.RMDupper")
     }
+    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
     doFirst {
-        from { configurations.runtime.collect { it.isDirectory() ? it : zipTree(it) } }
+        from { configurations.runtimeClasspath.collect { it.isDirectory() ? it : zipTree(it) } }
     }
 }
 
+
 task sourcesJar(type: Jar, dependsOn: classes) {
-    classifier = 'sources'
+    archiveClassifier.set('sources')
     from sourceSets.main.allSource
+    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
 }
 
+
 buildscript {
     repositories {
-        jcenter()
     }
     dependencies {
-        classpath 'com.jfrog.bintray.gradle:gradle-bintray-plugin:1.8.0'
     }
 }
 
+
 allprojects {
     repositories {
-        jcenter()
     }
-    apply plugin: 'maven'
     apply plugin: 'maven-publish'
     apply plugin: 'java'
     apply plugin: 'idea'
-    apply plugin: 'com.jfrog.bintray'
 }
 
+
 publishing {
     publications {
         MyPublication(MavenPublication) {
@@ -82,37 +87,14 @@ publishing {
     }
 }
 
+
 jacocoTestReport {
     reports {
-        xml.enabled true
+        xml.required.set(true)
     }
 }
 
 
-bintray {
-    user = System.getenv('BINTRAY_USER')
-    key = System.getenv('BINTRAY_API_KEY')
-    publications = ['MyPublication']
-    publish = true
-    override = true
-    pkg {
-        repo = 'EAGER'
-        name = 'DeDup'
-        licenses = ['GPL-3.0']
-        vcsUrl = "https://github.com/apeltzer/DeDup"
-        version {
-            name = project.version
-            desc = 'Duplicate removal for merged reads.'
-            released  = new Date()
-            vcsTag = project.version
-            attributes = ['gradle-plugin': 'com.use.less:com.use.less.gradle:gradle-useless-plugin']
-        }
-
-    }
-}
-
-
-
 artifacts {
     archives sourcesJar //, javadocJar
 }
