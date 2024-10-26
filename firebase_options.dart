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
    apiKey: 'AIzaSyBcU9ksRC-f2DKh5fnTplPMUoZY_1-tPJU',
    appId: '1:112973796178:web:2fbe12794e02c8098fa08b',
    messagingSenderId: '112973796178',
    projectId: 'final-7ad71',
    authDomain: 'final-7ad71.firebaseapp.com',
    storageBucket: 'final-7ad71.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCd5McoYfPe00lORy8Wx08SH4YaherLOx8',
    appId: '1:112973796178:android:e3cb3283c9add4918fa08b',
    messagingSenderId: '112973796178',
    projectId: 'final-7ad71',
    storageBucket: 'final-7ad71.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzowhWp8vTOHE6pKbHxukS_POCRTVIzps',
    appId: '1:112973796178:ios:db57b88983de00dc8fa08b',
    messagingSenderId: '112973796178',
    projectId: 'final-7ad71',
    storageBucket: 'final-7ad71.appspot.com',
    iosBundleId: 'dev.jideguru.flutterEbookApp234',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBzowhWp8vTOHE6pKbHxukS_POCRTVIzps',
    appId: '1:112973796178:ios:ee40af5b232606258fa08b',
    messagingSenderId: '112973796178',
    projectId: 'final-7ad71',
    storageBucket: 'final-7ad71.appspot.com',
    iosBundleId: 'dev.jideguru.flutterEbookApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBcU9ksRC-f2DKh5fnTplPMUoZY_1-tPJU',
    appId: '1:112973796178:web:ff5d375170e701198fa08b',
    messagingSenderId: '112973796178',
    projectId: 'final-7ad71',
    authDomain: 'final-7ad71.firebaseapp.com',
    storageBucket: 'final-7ad71.appspot.com',
  );

}