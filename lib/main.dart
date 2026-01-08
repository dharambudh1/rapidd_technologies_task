import "dart:async";
import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rapidd_technologies_task/screens/splash/splash_screen.dart";
import "package:rapidd_technologies_task/services/firebase_service.dart";

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await FirebaseService().initializeApp();

      runApp(const ProviderScope(child: MainApp()));
    },
    (Object error, StackTrace stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
