import "dart:developer";

import "package:google_sign_in/google_sign_in.dart";

class GoogleSignInService {
  factory GoogleSignInService() {
    return _singleton;
  }

  GoogleSignInService._internal();
  static final GoogleSignInService _singleton = GoogleSignInService._internal();

  Future<GoogleSignInAccount?> signInSilently() async {
    GoogleSignInAccount? currentUser;

    try {
      currentUser = await GoogleSignIn().signInSilently();

      log("User signed in silently: ${currentUser?.displayName ?? ""}");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<GoogleSignInAccount?>.value(currentUser);
  }

  Future<GoogleSignInAccount?> signIn() async {
    GoogleSignInAccount? currentUser;

    try {
      currentUser = await GoogleSignIn().signIn();

      log("User signed in: ${currentUser?.displayName ?? ""}");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<GoogleSignInAccount?>.value(currentUser);
  }

  Future<GoogleSignInAccount?> signOut() async {
    GoogleSignInAccount? currentUser;

    try {
      await GoogleSignIn().signOut();

      log("User signed out");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<GoogleSignInAccount?>.value(currentUser);
  }
}
