import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:rapidd_technologies_task/models/user.dart";

class UserCrudService {
  factory UserCrudService() {
    return _singleton;
  }

  UserCrudService._internal();
  static final UserCrudService _singleton = UserCrudService._internal();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get collection {
    const String name = "users";
    return firestore.collection(name);
  }

  Future<void> create(User user) async {
    try {
      await collection.add(user.toJson());
      log("User created: ${user.toJson()}");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}
  }

  Future<User> getById(String id) async {
    User value = const User();

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await collection
          .doc(id)
          .get();
      value = (doc.exists && doc.data() != null)
          ? User.fromJson(doc.data() ?? <String, dynamic>{})
          : const User();
      log("Get user: ${value.toJson()}");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return value;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await collection.doc(id).update(data);
      log("User updated: $id with data: $data");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<void>.value();
  }

  Future<void> upsert(String id, User user) async {
    try {
      await collection.doc(id).set(user.toJson(), SetOptions(merge: true));
      log("User upserted: $id with data: ${user.toJson()}");
    } on Exception catch (error, stackTrace) {
      log("Exception in upsert", error: error, stackTrace: stackTrace);
    }
  }

  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
      log("User deleted: $id");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<void>.value();
  }
}
