import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:rapidd_technologies_task/controllers/auth/auth_controller.dart";
import "package:rapidd_technologies_task/screens/auth/auth_screen.dart";
import "package:rapidd_technologies_task/screens/dashboard/dashboard_screen.dart";

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = ref.watch(authProvider);

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) async {
      if (mounted) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) {
              return (user != null)
                  ? const DashboardScreen()
                  : const AuthScreen();
            },
          ),
        );
      }
    });

    return const Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
