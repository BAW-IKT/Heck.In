# HedgeProfilerFlutter
BAW Hedge Profiler Flutter (Android/IOS App)

# Prerequirements
## Install Flutter SDK
- Download from https://docs.flutter.dev/get-started/install
- Extract to `C:\TOOLS\flutter`
- Modify path in `local.properties`

## Install Android Subsystem for Windows (WSA)
- Run from cmd: `winget install --id=9P3395VX91NR -e --accept-package-agreements`
- Alternatively: Open Microsoft Store --> Install amazon Appstore (automatically also installs android subsystem)
- Configure WSA: Windows key --> `Windows Subsystem for Android Settings`
  - System: Subsystem resources: Continuous
  - System: Advanced networking: On
  - Developer: Developer mode: On
  - Click `Manage developer settings` once to start WSA --> close --> switch tab to `System` and back to `Developer` to refresh IP --> remember IP and **port**!

## Prepare filesystem
- create local folder, must contain only lower case and underscores (e.g. `C:\repos\hedge_profiler_flutter`
- clone repo: `git clone https://github.com/Mnikley/HedgeProfilerFlutter .`

## Load project in IntelliJ
- Install Flutter Plugin if running on IntelliJ
- Set path to flutter SDK: `Ctrl+Alt+S` --> `Languages & Frameworks` --> `Flutter` --> set `Flutter SDK Path:` to `C:\TOOLS\flutter`
- Install JDK: `Ctrl+Alt+S` --> `SDK` --> `Add SDK` --> `Download SDK` --> **Some Java version >= 8** (don't go over JDK 16, as Gradle has to be compatible with the Java version, see: https://docs.gradle.org/current/userguide/compatibility.html#java)
- Install Android SDK: `Alt+Ctrl+S` --> `Appearance & Behavior` --> `System Settings` --> `Android SDK` --> `Edit` next to `Android SDK Location` --> Install `Android SDK` and latest `API`
- Set Project SDK to Android: `Ctrl+Alt+Shift+S` --> `SDK:` select recently installed `Android API XX`
- Restart IntelliJ

## Install Android Debugging Bridge (ADB) and add to Path
- Install Android SDK Platform tools: https://dl.google.com/android/repository/platform-tools-latest-windows.zip
- Extract to `C:\TOOLS\platform-tools`, copy path to clipboard
- Add platform-tools to PATH: (Windows key --> `Edit the system environment variables` --> `Environment variables ..` --> `User variables for XXX` --> double click `Path` --> `New` --> paste from clipboard)
- Add JDK to PATH: `New` --> `%USERPROFILE%\.jdks\corretto-16.0.2\bin` (adapt corretto-16.0.2 to your installed JDK version)
- restart console, test both paths were added successfully:
  - adb can connect to android adapter with: `adb connect 127.0.0.1:58526`, replace with your **port**
  - test the command `java` returns something

## Install flutter dependency webview_flutter
- documentation: https://pub.dev/packages/webview_flutter
- navigate to repo, add with: `flutter pub add webview_flutter
- install with: `flutter pub get`

## Run project in Android Studio:
- Edit run configuration `my_app.dart` --> edit before launch --> add external tool:
  - Name: adb
  - Program: `C:\TOOLS\platform-tools\adb.exe`
  - Arguments: `connect 127.0.0.1:58526`
- Alternatively connect to adb from commandline: `adb connect 127.0.0.1:58526`
- Run configuration once, at first run accept RSA fingerprint, check accept this device
- select `Subsystem for Android TM (mobile)` from the Flutter Device Selection
- run `my_app.dart`

If an error *Could not identify launch activity* or similar appears, make sure to add a `package="com.example.hedge_profiler"` to the `<mainfest>` tag in `android/app/src/main/AndroidManifest.xml`:
![image](https://user-images.githubusercontent.com/75040444/232093628-24f31a74-5f48-467b-a1c8-d9136ee4329c.png)

  
