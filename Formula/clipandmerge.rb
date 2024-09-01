class Clipandmerge < Formula
  desc "Paired-end read merging and adapter clipping, quality trimming, etc."
  homepage "https://github.com/apeltzer/ClipAndMerge"
  url "https://github.com/apeltzer/ClipAndMerge/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "b5cde73422e3ef1809ce42aaff26246760eaf88c3981c6a400f0eb769ba5229f"
  license "GPL-3.0-or-later"
  head "https://github.com/apeltzer/ClipAndMerge.git", branch: "master"

  depends_on "gradle" => :build
  depends_on "openjdk@11" => :build

  patch :DATA

  def install
    system "gradle", "build"
    jar = "build/libs/ClipAndMerge-#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "ClipAndMerge", java_version: "11"
  end

  test do
    assert_match "ClipAndMerge (v. #{version})", shell_output("#{bin}/ClipAndMerge -h 2>&1")
  end
end
__END__
diff --git a/build.gradle b/build.gradle
index 349365e..8a8eec1 100644
--- a/build.gradle
+++ b/build.gradle
@@ -4,30 +4,22 @@ version '1.7.8'
 apply plugin: 'java'
 apply plugin: 'jacoco'
 apply plugin: 'idea'
-apply plugin: 'maven'
 apply plugin: 'maven-publish'
-apply plugin: 'com.jfrog.bintray'
 
 
 repositories {
     mavenCentral()
-    jcenter()
 }
 
 
 buildscript {
     repositories {
-        jcenter()
     }
     dependencies {
-        classpath 'com.jfrog.bintray.gradle:gradle-bintray-plugin:1.8.0'
     }
 }
 
 
-sourceCompatibility = 1.8
-
-
 sourceSets {
     main {
         java {
@@ -38,10 +30,14 @@ sourceSets {
 
 
 dependencies {
-    compile 'args4j:args4j:2.33'
-    compile 'junit:junit:4.12'
-    testCompile group: 'junit', name: 'junit', version: '4.12'
-    compile "org.mockito:mockito-core:2.+"
+    implementation 'args4j:args4j:2.33'
+    implementation 'junit:junit:4.12'
+    testImplementation group: 'junit', name: 'junit', version: '4.12'
+    implementation "org.mockito:mockito-core:2.+"
+}
+
+
+java {
 }
 
 
@@ -50,8 +46,9 @@ jar {
         attributes("Implementation-Title": "ClipAndMerge",
                 "Implementation-Version": "1.7.8", "main-Class": "main.MergeScript")
     }
+    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
     doFirst {
-        from { configurations.runtime.collect { it.isDirectory() ? it : zipTree(it) } }
+        from { configurations.runtimeClasspath.collect { it.isDirectory() ? it : zipTree(it) } }
     }
 }
 
@@ -69,29 +66,6 @@ publishing {
 
 jacocoTestReport {
     reports {
-        xml.enabled true
-    }
-}
-
-
-bintray {
-    user = System.getenv('BINTRAY_USER')
-    key = System.getenv('BINTRAY_API_KEY')
-    publications = ['MyPublication']
-    publish = true
-    override = true
-    pkg {
-        repo = 'EAGER'
-        name = 'ClipAndMerge'
-        licenses = ['GPL-3.0']
-        vcsUrl = "https://github.com/apeltzer/ClipAndMerge"
-        version {
-            name = project.version
-            desc = 'The Clip&Merge Method for paired end read merging and adapter clipping, quality trimming and other FastQ operations.'
-            released  = new Date()
-            vcsTag = project.version
-            attributes = ['gradle-plugin': 'com.use.less:com.use.less.gradle:gradle-useless-plugin']
-        }
-
+        xml.required.set(true)
     }
 }
