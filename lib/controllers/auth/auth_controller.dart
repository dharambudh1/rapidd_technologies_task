import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:rapidd_technologies_task/models/user.dart";
import "package:rapidd_technologies_task/services/google_sign_in_service.dart";

final StateNotifierProvider<AuthController, GoogleSignInAccount?> authProvider =
    StateNotifierProvider<AuthController, GoogleSignInAccount?>((Ref ref) {
      return AuthController();
    });

class AuthController extends StateNotifier<GoogleSignInAccount?> {
  AuthController() : super(null) {
    unawaited(signInSilently());
  }

  Future<void> signInSilently() async {
    state = await GoogleSignInService().signInSilently();

    return Future<void>.value();
  }

  Future<User> signIn() async {
    state = await GoogleSignInService().signIn();

    final User user = (state != null)
        ? User(
            id: state?.id ?? "",
            email: state?.email ?? "",
            name: state?.displayName ?? "",
          )
        : const User();

    return Future<User>.value(user);
  }

  Future<void> signOut() async {
    state = await GoogleSignInService().signOut();

    return Future<void>.value();
  }
}
