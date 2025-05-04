# Flutter
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Just Audio & ExoPlayer
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class com.ryanheise.just_audio.** { *; }
-dontwarn com.ryanheise.just_audio.**

# For Provider and reflection
-keep class com.example.zen_circuit.** { *; }

# Prevent obfuscation of model classes (optional)
-keep class *.model.** { *; }

# Allow access to localizations
-keep class * extends flutter_localizations.** { *; }

# General AndroidX support
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**

# Needed for reflection used by Firebase Auth and Firestore
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.firebase.auth.** { *; }
-keep class com.google.firebase.firestore.** { *; }

# Disable warnings
-dontnote
-dontwarn