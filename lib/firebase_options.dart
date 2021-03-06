// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJubtTOI8NhK69CRR0Y0p5dzrYk8UZlRw',
    appId: '1:763347747830:web:4af12f1c853ea8504dfdd7',
    messagingSenderId: '763347747830',
    projectId: 'quando-91d33',
    authDomain: 'quando-91d33.firebaseapp.com',
    databaseURL: 'https://quando-91d33-default-rtdb.firebaseio.com',
    storageBucket: 'quando-91d33.appspot.com',
    measurementId: 'G-WBCR6SYC38',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCC81HvRXbnO1H_3EebgmJWe_M2zweS_RM',
    appId: '1:763347747830:android:09ebd70d46284c5f4dfdd7',
    messagingSenderId: '763347747830',
    projectId: 'quando-91d33',
    databaseURL: 'https://quando-91d33-default-rtdb.firebaseio.com',
    storageBucket: 'quando-91d33.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCGdvuvs6irT4cW-Id7Ucrj4raaYClBjo',
    appId: '1:763347747830:ios:f8238562092540644dfdd7',
    messagingSenderId: '763347747830',
    projectId: 'quando-91d33',
    databaseURL: 'https://quando-91d33-default-rtdb.firebaseio.com',
    storageBucket: 'quando-91d33.appspot.com',
    iosClientId: '763347747830-4bfv43sjlga8bplij20ia90h6focag17.apps.googleusercontent.com',
    iosBundleId: 'com.nicholaspiazza.quando',
  );
}
