import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_ui_firestore/firebase_ui_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:rapidd_technologies_task/controllers/auth/auth_controller.dart";
import "package:rapidd_technologies_task/controllers/dashboard/dashboard_controller.dart";
import "package:rapidd_technologies_task/controllers/others/task_controller.dart";
import "package:rapidd_technologies_task/models/task.dart";
import "package:rapidd_technologies_task/screens/auth/auth_screen.dart";
import "package:rapidd_technologies_task/screens/note/note_screen.dart";
import "package:rapidd_technologies_task/services/task_crud_service.dart";
import "package:rapidd_technologies_task/utils/debounce_util.dart";
import "package:rapidd_technologies_task/utils/keep_alive_wrapper.dart";

final TextEditingController searchController = TextEditingController();

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        ref.read(indexProvider.notifier).set(tabController.index);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = ref.watch(authProvider);

    final AuthController authController = ref.read(authProvider.notifier);

    final TaskController taskController = ref.read(taskProvider.notifier);

    final int index = ref.watch(indexProvider);

    final String searchString = ref.watch(searchProvider);

    ref.listen<GoogleSignInAccount?>(authProvider, (
      GoogleSignInAccount? previous,
      GoogleSignInAccount? next,
    ) async {
      if (next == null && mounted) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) {
              return const AuthScreen();
            },
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Hi, ${user?.email ?? ""}",
          style: const TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: authController.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + kToolbarHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(hintText: "Search Tasks"),
                  onChanged: (String value) {
                    DebounceUtil().debounce(() {
                      ref.read(searchProvider.notifier).set(value);
                    });
                  },
                ),
              ),
              TabBar(
                controller: tabController,
                tabs: const <Tab>[
                  Tab(text: "Created by Me"),
                  Tab(text: "Assigned to Me"),
                ],
                onTap: (int value) {
                  ref.read(indexProvider.notifier).set(value);
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: tabController,
          children: <Widget>[
            KeepAliveWrapper(
              child: listViewWidget(
                Filter("ownerEmail", isEqualTo: user?.email ?? ""),
                searchString,
              ),
            ),
            KeepAliveWrapper(
              child: listViewWidget(
                Filter("sharedWith", arrayContains: user?.email ?? ""),
                searchString,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: () async {
                final String id = "${DateTime.now().millisecondsSinceEpoch}";

                await taskController.upsert(
                  id,
                  Task(
                    id: id,
                    title: "New Task",
                    description: "Task Description",
                    ownerEmail: user?.email ?? "",
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget listViewWidget(Filter filter, String searchText) {
    final Query<Task> query = TaskCrudService().collection
        .where(filter)
        .orderBy(FieldPath.documentId, descending: true)
        .withConverter<Task>(
          fromFirestore:
              (
                DocumentSnapshot<Map<String, dynamic>> snapshot,
                SnapshotOptions? options,
              ) {
                return Task.fromJson(snapshot.data() ?? <String, dynamic>{});
              },
          toFirestore: (Task user, SetOptions? options) {
            return user.toJson();
          },
        );

    return FirestoreListView<Task>.separated(
      query: query,
      itemBuilder:
          (BuildContext context, QueryDocumentSnapshot<Task> snapshot) {
            final Task task = snapshot.data();

            final String title = (task.title ?? "").toLowerCase();

            final String description = (task.description ?? "").toLowerCase();

            final bool matchesSearch =
                searchText.isEmpty ||
                title.contains(searchText) ||
                description.contains(searchText);

            if (!matchesSearch) {
              return const SizedBox.shrink();
            }

            return ListTile(
              title: Text(task.title ?? ""),
              subtitle: Text(task.description ?? ""),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) {
                      return NoteScreen(task: task);
                    },
                  ),
                );
              },
            );
          },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 0);
      },
      emptyBuilder: (BuildContext context) {
        return const Center(child: Text("No tasks found."));
      },
    );
  }
}
