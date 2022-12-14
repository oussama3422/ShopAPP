// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA0bgWnOLqFnT-xHGwNErnZLrOzRgy-Kcg',
    appId: '1:135590639085:web:7cf6a8c9c3edc85732e3e4',
    messagingSenderId: '135590639085',
    projectId: 'fir-app-aee08',
    authDomain: 'fir-app-aee08.firebaseapp.com',
    databaseURL: 'https://fir-app-aee08-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-aee08.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2ZMKDABPEh0irCo8zMxE_v0xQV2chfCc',
    appId: '1:135590639085:android:70b31803d24cbf7732e3e4',
    messagingSenderId: '135590639085',
    projectId: 'fir-app-aee08',
    databaseURL: 'https://fir-app-aee08-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-aee08.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmClCkDZrxi8Q_dQKgFm-4hGSsD-PIRO4',
    appId: '1:135590639085:ios:8154362d3d1cd5d832e3e4',
    messagingSenderId: '135590639085',
    projectId: 'fir-app-aee08',
    databaseURL: 'https://fir-app-aee08-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-aee08.appspot.com',
    iosClientId: '135590639085-s6sr8vfd2ftekls3ifeus942ct8cftu3.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBmClCkDZrxi8Q_dQKgFm-4hGSsD-PIRO4',
    appId: '1:135590639085:ios:8154362d3d1cd5d832e3e4',
    messagingSenderId: '135590639085',
    projectId: 'fir-app-aee08',
    databaseURL: 'https://fir-app-aee08-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-aee08.appspot.com',
    iosClientId: '135590639085-s6sr8vfd2ftekls3ifeus942ct8cftu3.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
