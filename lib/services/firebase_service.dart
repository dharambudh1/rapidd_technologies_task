import "dart:developer";

import "package:firebase_core/firebase_core.dart";
import "package:rapidd_technologies_task/firebase_options/firebase_options.dart";

class FirebaseService {
  factory FirebaseService() {
    return _singleton;
  }

  FirebaseService._internal();
  static final FirebaseService _singleton = FirebaseService._internal();

  Future<void> initializeApp() async {
    try {
      final FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;
      final FirebaseApp app = await Firebase.initializeApp(options: options);
      log("Firebase initialized successfully with name: ${app.name}");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<void>.value();
  }
}
