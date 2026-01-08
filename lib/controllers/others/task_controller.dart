import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:rapidd_technologies_task/models/task.dart";
import "package:rapidd_technologies_task/services/task_crud_service.dart";

final StateNotifierProvider<TaskController, Task?> taskProvider =
    StateNotifierProvider<TaskController, Task?>((Ref ref) {
      return TaskController();
    });

class TaskController extends StateNotifier<Task?> {
  TaskController() : super(null);

  Future<void> create(Task task) async {
    await TaskCrudService().create(task);

    return Future<void>.value();
  }

  Future<Task> getById(String id) async {
    final Task task = await TaskCrudService().getById(id);

    state = task;

    return Future<Task>.value(state);
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await TaskCrudService().update(id, data);

    return Future<void>.value();
  }

  Future<void> upsert(String id, Task task) async {
    await TaskCrudService().upsert(id, task);

    return Future<void>.value();
  }

  Future<void> delete(String id) async {
    await TaskCrudService().delete(id);

    return Future<void>.value();
  }

  Future<void> shareWithEmail(String id, String email) async {
    final Task task = await getById(id);

    await update(id, <String, dynamic>{
      "sharedWith": <dynamic>[...(task.sharedWith ?? <String>[]), email],
    });

    return Future<void>.value();
  }
}
