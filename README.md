# QRIS WebView Integration Guide (Flutter)

This guide explains how to embed a **WebView** in a Flutter application using the [`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview) package. It includes instructions for handling camera and loading a remote URL.

---

## Dependencies

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_inappwebview: ^6.1.5
  permission_handler: ^12.0.0+1
```

## Required Permissions
### Android Setup
In your `AndroidManifest.xml`, 
- Add the required permissions:
    ```xml
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    ```

- Inside the `<application>` tag, include:
    ```xml        
    <application
    ...
    android:usesCleartextTraffic="true"
    android:hardwareAccelerated="true"
    >
    ```

### IOS Setup
In your `Info.plist`,
- Add camera and microphone permission descriptions:
    ```xml    
    <key>NSCameraUsageDescription</key>
    <string>We need camera access to scan QR codes.</string>
    ```
- Enable embedded WebView support:
    ```xml       
    <key>io.flutter.embedded_views_preview</key>
    <true/>
    ```

## Example
You can find a sample implementation in `lib/main.dart.`






