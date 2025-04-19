// File generated based on your firebase configuration
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can create it with the Firebase CLI',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can create it with the Firebase CLI',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can create it with the Firebase CLI',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can create it with the Firebase CLI',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLV7HBvK6toZn1Ye4GDeOshCcveYfnvd0',
    appId: '1:144098574804:android:40e7b6213a161e2f441641',
    messagingSenderId: '144098574804',
    projectId: 'nuvilab-d7261',
    storageBucket: 'nuvilab-d7261.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUG384IUvOq4UdDerkVFz6bJPCtzWeNSU',
    appId: '1:144098574804:ios:b1522940023c366b441641',
    messagingSenderId: '144098574804',
    projectId: 'nuvilab-d7261',
    storageBucket: 'nuvilab-d7261.firebasestorage.app',
    iosClientId:
        '144098574804-a1l2m9kla1h1c9epu4i0jm8sg2nt0i2s.apps.googleusercontent.com',
    iosBundleId: 'com.example.nubilab',
  );
}
