import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:rapidd_technologies_task/models/task.dart";

class TaskCrudService {
  factory TaskCrudService() {
    return _singleton;
  }

  TaskCrudService._internal();
  static final TaskCrudService _singleton = TaskCrudService._internal();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get collection {
    const String name = "tasks";
    return firestore.collection(name);
  }

  Future<void> create(Task task) async {
    try {
      await collection.add(task.toJson());
      log("Task created: ${task.toJson()}");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}
  }

  Future<Task> getById(String id) async {
    Task value = const Task();

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await collection
          .doc(id)
          .get();
      value = (doc.exists && doc.data() != null)
          ? Task.fromJson(doc.data() ?? <String, dynamic>{})
          : const Task();
      log("Get task: ${value.toJson()}");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return value;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await collection.doc(id).update(data);
      log("Task updated: $id with data: $data");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<void>.value();
  }

  Future<void> upsert(String id, Task task) async {
    try {
      await collection.doc(id).set(task.toJson(), SetOptions(merge: true));
      log("Task upserted: $id with data: ${task.toJson()}");
    } on Exception catch (error, stackTrace) {
      log("Exception in upsert", error: error, stackTrace: stackTrace);
    }
  }

  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
      log("Task deleted: $id");
    } on Exception catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<void>.value();
  }
}
