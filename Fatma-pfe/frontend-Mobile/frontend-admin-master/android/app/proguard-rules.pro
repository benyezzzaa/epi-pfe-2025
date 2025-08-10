# --- ML Kit Text Recognition keep rules ---
# Keep all ML Kit public APIs and internal classes used via reflection
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google.android.gms.dynamite.** { *; }
-keep class com.google.android.gms.common.internal.safeparcel.SafeParcelable { *; }

# Avoid warnings from shaded/internal ML Kit packages
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.internal.mlkit_**
-dontwarn com.google.android.gms.dynamite.**
