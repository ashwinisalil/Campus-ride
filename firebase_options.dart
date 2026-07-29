import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA_TRACKME_WEB_KEY_MOCK',
    appId: '1:102030405060:web:trackme12345',
    messagingSenderId: '102030405060',
    projectId: 'trackme-smart-campus',
    authDomain: 'trackme-smart-campus.firebaseapp.com',
    storageBucket: 'trackme-smart-campus.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_TRACKME_ANDROID_KEY_MOCK',
    appId: '1:102030405060:android:trackme12345',
    messagingSenderId: '102030405060',
    projectId: 'trackme-smart-campus',
    storageBucket: 'trackme-smart-campus.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_TRACKME_IOS_KEY_MOCK',
    appId: '1:102030405060:ios:trackme12345',
    messagingSenderId: '102030405060',
    projectId: 'trackme-smart-campus',
    storageBucket: 'trackme-smart-campus.appspot.com',
    iosBundleId: 'com.campus.trackme',
  );
}
