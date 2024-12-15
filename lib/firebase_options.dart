// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```


// ...
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAoWFvyWgCgIlE-vEmoLkgz7aKKWMOIIGo',
    appId: '1:1019663689630:web:9af15e632de2fa6072988f',
    messagingSenderId: '1019663689630',
    projectId: 'appointment-3b884',
    authDomain: 'appointment-3b884.firebaseapp.com',
    storageBucket: 'appointment-3b884.firebasestorage.app',
    measurementId: 'G-P2Z9E015S4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4gDgNXgUH_lXORDmp8RXupPwUdX_hBjo',
    appId: '1:1019663689630:android:a5ac6eaaa957374272988f',
    messagingSenderId: '1019663689630',
    projectId: 'appointment-3b884',
    storageBucket: 'appointment-3b884.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuZrvKN83xPtiV1gONDzphA-iBiHdSuO8',
    appId: '1:1019663689630:ios:6f9e6b311e79ea1072988f',
    messagingSenderId: '1019663689630',
    projectId: 'appointment-3b884',
    storageBucket: 'appointment-3b884.firebasestorage.app',
    iosBundleId: 'com.example.appointmentbooker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuZrvKN83xPtiV1gONDzphA-iBiHdSuO8',
    appId: '1:1019663689630:ios:6f9e6b311e79ea1072988f',
    messagingSenderId: '1019663689630',
    projectId: 'appointment-3b884',
    storageBucket: 'appointment-3b884.firebasestorage.app',
    iosBundleId: 'com.example.appointmentbooker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAoWFvyWgCgIlE-vEmoLkgz7aKKWMOIIGo',
    appId: '1:1019663689630:web:e7e4ef07013a5ce372988f',
    messagingSenderId: '1019663689630',
    projectId: 'appointment-3b884',
    authDomain: 'appointment-3b884.firebaseapp.com',
    storageBucket: 'appointment-3b884.firebasestorage.app',
    measurementId: 'G-7MXY7CKWW1',
  );
}