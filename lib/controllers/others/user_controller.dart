import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:rapidd_technologies_task/models/user.dart";
import "package:rapidd_technologies_task/services/user_crud_service.dart";

final StateNotifierProvider<UserController, User?> userProvider =
    StateNotifierProvider<UserController, User?>((Ref ref) {
      return UserController();
    });

class UserController extends StateNotifier<User?> {
  UserController() : super(null);

  Future<void> create(User user) async {
    await UserCrudService().create(user);

    return Future<void>.value();
  }

  Future<User> getById(String id) async {
    final User user = await UserCrudService().getById(id);

    state = user;

    return Future<User>.value(state);
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await UserCrudService().update(id, data);

    return Future<void>.value();
  }

  Future<void> upsert(String id, User user) async {
    await UserCrudService().upsert(id, user);

    return Future<void>.value();
  }

  Future<void> delete(String id) async {
    await UserCrudService().delete(id);

    return Future<void>.value();
  }
}
