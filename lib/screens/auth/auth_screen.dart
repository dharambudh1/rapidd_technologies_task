import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:rapidd_technologies_task/controllers/auth/auth_controller.dart";
import "package:rapidd_technologies_task/controllers/others/user_controller.dart";
import "package:rapidd_technologies_task/models/user.dart";
import "package:rapidd_technologies_task/screens/dashboard/dashboard_screen.dart";

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = ref.read(authProvider.notifier);

    final UserController userController = ref.read(userProvider.notifier);

    ref.listen<GoogleSignInAccount?>(authProvider, (
      GoogleSignInAccount? previous,
      GoogleSignInAccount? next,
    ) async {
      if (next != null && mounted) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) {
              return const DashboardScreen();
            },
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              final User user = await authController.signIn();

              final bool res = !mapEquals(user.toJson(), const User().toJson());

              if (res) {
                await userController.upsert(user.id ?? "", user);
              }
            },
            child: const Text("Google Sign In"),
          ),
        ),
      ),
    );
  }
}
