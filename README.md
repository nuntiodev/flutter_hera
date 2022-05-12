## Welcome to Dart Blocks
This is an SDK that you can use to connect your services or apps to Nuntio Cloud or self-hosted Nuntio Blocks.

## Usage
To add the geolocator to your Flutter application read the [install](https://pub.dev/packages/geolocator/install) instructions. Below are some Android and iOS specifics that are required for the geolocator to work correctly.

<details>
<summary>Android</summary>

**Upgrade pre 1.12 Android projects**

Since version 5.0.0 this plugin is implemented using the Flutter 1.12 Android plugin APIs. Unfortunately this means App developers also need to migrate their Apps to support the new Android infrastructure. You can do so by following the [Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects) migration guide. Failing to do so might result in unexpected behaviour.

**AndroidX**

The geolocator plugin requires the AndroidX version of the Android Support Libraries. This means you need to make sure your Android project supports AndroidX. Detailed instructions can be found [here](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility).

The TL;DR version is:

1. Add the following to your "gradle.properties" file:

```
android.useAndroidX=true
android.enableJetifier=true
```
2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 31:

```
android {
  compileSdkVersion 31

  ...
}
```
3. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found here: [Migrating to AndroidX](https://developer.android.com/jetpack/androidx/migrate)).

**Permissions**

On Android you'll need to add either the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission to your Android Manifest. To do so open the AndroidManifest.xml file (located under android/app/src/main) and add one of the following two lines as direct children of the `<manifest>` tag (when you configure both permissions the `ACCESS_FINE_LOCATION` will be used by the geolocator plugin):

``` xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Starting from Android 10 you need to add the `ACCESS_BACKGROUND_LOCATION` permission (next to the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission) if you want to continue receiving updates even when your App is running in the background (note that the geolocator plugin doesn't support receiving an processing location updates while running in the background):

``` xml
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

> **NOTE:** Specifying the `ACCESS_COARSE_LOCATION` permission results in location updates with an accuracy approximately equivalent to a city block. It might take a long time (minutes) before you will get your first locations fix as `ACCESS_COARSE_LOCATION` will only use the network services to calculate the position of the device. More information can be found [here](https://developer.android.com/training/location/retrieve-current#permissions).


</details>

<details>
<summary>iOS</summary>

On iOS you'll need to add the following entries to your Info.plist file (located under ios/Runner) in order to access the device's location. Simply open your Info.plist file and add the following (make sure you update the description so it is meaningfull in the context of your App):

``` xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
```

If you would like to receive updates when your App is in the background, you'll also need to add the Background Modes capability to your XCode project (Project > Signing and Capabilities > "+ Capability" button) and select Location Updates. Be careful with this, you will need to explain in detail to Apple why your App needs this when submitting your App to the AppStore. If Apple isn't satisfied with the explanation your App will be rejected.

When using the `requestTemporaryFullAccuracy({purposeKey: "YourPurposeKey"})` method, a dictionary should be added to the Info.plist file.
```xml
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
  <key>YourPurposeKey</key>
  <string>The example App requires temporary access to the device&apos;s precise location.</string>
</dict>
```
The second key (in this example called `YourPurposeKey`) should match the purposeKey that is passed in the `requestTemporaryFullAccuracy()` method. It is possible to define multiple keys for different features in your app. More information can be found in Apple's [documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary).

> NOTE: the first time requesting temporary full accuracy access it might take several seconds for the pop-up to show. This is due to the fact that iOS is determining the exact user location which may take several seconds. Unfortunately this is out of our hands.
</details>

<details>
<summary>macOS</summary>

On macOS you'll need to add the following entries to your Info.plist file (located under macOS/Runner) in order to access the device's location. Simply open your Info.plist file and add the following (make sure you update the description so it is meaningfull in the context of your App):

``` xml
<key>NSLocationUsageDescription</key>
<string>This app needs access to location.</string>
```

You will also have to add the following entry to the DebugProfile.entitlements and Release.entitlements files. This will declare that your App wants to make use of the device's location services and adds it to the list in the "System Preferences" -> "Security & Privace" -> "Privacy" settings.
```xml
<key>com.apple.security.personal-information.location</key>
<true/>
```

When using the `requestTemporaryFullAccuracy({purposeKey: "YourPurposeKey"})` method, a dictionary should be added to the Info.plist file.
```xml
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
  <key>YourPurposeKey</key>
  <string>The example App requires temporary access to the device&apos;s precise location.</string>
</dict>
```
The second key (in this example called `YourPurposeKey`) should match the purposeKey that is passed in the `requestTemporaryFullAccuracy()` method. It is possible to define multiple keys for different features in your app. More information can be found in Apple's [documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary).

> NOTE: the first time requesting temporary full accuracy access it might take several seconds for the pop-up to show. This is due to the fact that macOS is determining the exact user location which may take several seconds. Unfortunately this is out of our hands.
</details>

<details>
<summary>Web</summary>

To use the Geolocator plugin on the web you need to be using Flutter 1.20 or higher. Flutter will automatically add the endorsed [geolocator_web]() package to your application when you add the `geolocator: ^6.2.0` dependency to your `pubspec.yaml`.

The following methods of the geolocator API are not supported on the web and will result in a `PlatformException` with the code `UNSUPPORTED_OPERATION`:

- `getLastKnownPosition({ bool forceAndroidLocationManager = true })`
- `openAppSettings()`
- `openLocationSettings()`

**NOTE**

Geolocator Web is available only in [secure_contexts](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts) (HTTPS). More info about the Geolocator API can be found [here](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API).

</details>

<details>
<summary>Windows</summary>

To use the Geolocator plugin on Windows you need to be using Flutter 2.10 or higher. Flutter will automatically add the endorsed [geolocator_windows]() package to your application when you add the `geolocator: ^8.1.0` dependency to your `pubspec.yaml`.

## Bio storage

#### Android
* Requirements:
    * Android: API Level >= 23 (android/app/build.gradle `minSdkVersion 23`)
    * Make sure to use the latest kotlin version:
        * `android/build.gradle`: `ext.kotlin_version = '1.4.31'`
    * MainActivity must extend FlutterFragmentActivity
    * Theme for the main activity must use `Theme.AppCompat` thme.
      (Otherwise there will be crases on Android < 29)
      For example:

      **AndroidManifest.xml**:
      ```xml
      <activity
      android:name=".MainActivity"
      android:launchMode="singleTop"
      android:theme="@style/LaunchTheme"
      ```

      **xml/styles.xml**:
      ```xml
          <style name="LaunchTheme" parent="Theme.AppCompat.NoActionBar">
          <!-- Show a splash screen on the activity. Automatically removed when
               Flutter draws its first frame -->
          <item name="android:windowBackground">@drawable/launch_background</item>
  
          <item name="android:windowNoTitle">true</item>
          <item name="android:windowActionBar">false</item>
          <item name="android:windowFullscreen">true</item>
          <item name="android:windowContentOverlay">@null</item>
      </style>
      ```

##### Resources

* https://developer.android.com/topic/security/data
* https://developer.android.com/topic/security/best-practices

#### iOS

https://developer.apple.com/documentation/localauthentication/logging_a_user_into_your_app_with_face_id_or_touch_id

* include the NSFaceIDUsageDescription key in your app’s Info.plist file
* Requires at least iOS 9

#### Mac OS

* include the NSFaceIDUsageDescription key in your app’s Info.plist file
* enable keychain sharing and signing. (not sure why this is required. but without it
  You will probably see an error like:
  > SecurityError, Error while writing data: -34018: A required entitlement isn't present.
* Requires at least Mac OS 10.12

### Usage
