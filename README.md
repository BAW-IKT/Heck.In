# HedgeProfilerFlutter
BAW Hedge Profiler Flutter (Android/IOS App)

# Prerequirements
## Install Flutter SDK
- Download from https://docs.flutter.dev/get-started/install
- Extract to `C:\TOOLS\flutter`
- Modify path in `local.properties`

## Install Android Subsystem for Windows
- open Microsoft Store
- Install amazon Appstore (automatically also installs android subsystem)
- configure: Windows key --> `Windows Subsystem for Android Settings`
  - System: Subsystem resources: Continuous
  - System: Advanced networking: On
  - Developer: Developer mode: On
  - Developer: Developer mode: must mention the IP address of the android subsystem network adapter, mine was 127.0.0.1:58526, remember the **port**!

## Prepare filesystem
- create local folder, must contain only lower case and underscores (e.g. `C:\repos\hedge_profiler_flutter`
- clone repo: `git clone https://github.com/Mnikley/HedgeProfilerFlutter .`

## Load project in Android Studio
- Install Android SDK (i used API V33)
- Install JDK if necessary (i used 1.8 / 8)

## Add ADB to Path
- `cd %localappdata%` --> Android --> Sdk --> platform-tools --> copy path (e.g. `C:\Users\Matthias\AppData\Local\Android\Sdk\platform-tools`)
- add as environmental variable (User variables --> doubeclick `Path` --> `New` --> paste from clipboard)
- restart console, test adb can connect to android adapter with: `adb connect 127.0.0.1:58526`, replace with your **port**

## Install flutter dependency webview_flutter
- documentation: https://pub.dev/packages/webview_flutter
- navigate to repo, install with: `flutter pub add webview_flutter

## Run project in Android Studio:
- connect to adb once with `adb connect 127.0.0.1:58526`
- select `Subsystem for Android TM (mobile)` from the Flutter Device Selection
- run `my_app.dart`

  
