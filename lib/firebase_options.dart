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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAfchzccZZLZvlhRQ7YWNYNMc0kvoKVAJ4',
    appId: '1:898747829163:web:15e4d498cd1c5a436ba0ee',
    messagingSenderId: '898747829163',
    projectId: 'gestionpanneaux',
    authDomain: 'gestionpanneaux.firebaseapp.com',
    databaseURL: 'https://gestionpanneaux.firebaseio.com',
    storageBucket: 'gestionpanneaux.appspot.com',
    measurementId: 'G-S0SRJM9ZB2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBRXxiZJ0EM3wwt3Y60HFSrcBICR85TL8A',
    appId: '1:898747829163:android:3fb2ad5805edfe5f6ba0ee',
    messagingSenderId: '898747829163',
    projectId: 'gestionpanneaux',
    databaseURL: 'https://gestionpanneaux.firebaseio.com',
    storageBucket: 'gestionpanneaux.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4LOCW01cJiPqR2tDRNqTrfAnSZUNOPws',
    appId: '1:898747829163:ios:21ba1f144e59cd326ba0ee',
    messagingSenderId: '898747829163',
    projectId: 'gestionpanneaux',
    databaseURL: 'https://gestionpanneaux.firebaseio.com',
    storageBucket: 'gestionpanneaux.appspot.com',
    androidClientId: '898747829163-eje1bmtod9nmco6s506j2duui92sodjo.apps.googleusercontent.com',
    iosBundleId: 'com.example.newecommerce',
  );
}