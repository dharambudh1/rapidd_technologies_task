import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:rapidd_technologies_task/controllers/auth/auth_controller.dart";
import "package:rapidd_technologies_task/controllers/others/task_controller.dart";
import "package:rapidd_technologies_task/models/task.dart";
import "package:rapidd_technologies_task/utils/email_bottom_sheet.dart";

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({required this.task, super.key});

  final Task task;

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.task.title ?? "";

    descriptionController.text = widget.task.description ?? "";
  }

  @override
  void dispose() {
    titleController.dispose();

    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = ref.watch(authProvider);

    final TaskController taskController = ref.read(taskProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note"), actions: const <Widget>[]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: "Description"),
                  maxLines: null,
                  expands: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  if ((widget.task.ownerEmail ?? "") == (user?.email ?? ""))
                    FloatingActionButton(
                      heroTag: UniqueKey(),
                      onPressed: () async {
                        if ((widget.task.id ?? "").isEmpty) {
                          return;
                        }

                        await taskController.delete(widget.task.id ?? "");

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Icon(Icons.delete),
                    ),
                  if ((widget.task.ownerEmail ?? "") == (user?.email ?? ""))
                    const Spacer(),

                  if ((widget.task.ownerEmail ?? "") == (user?.email ?? ""))
                    FloatingActionButton(
                      heroTag: UniqueKey(),
                      onPressed: () async {
                        if ((widget.task.id ?? "").isEmpty) {
                          return;
                        }

                        final String email =
                            await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return const EmailBottomSheet();
                              },
                            ) ??
                            "";

                        if (email.isEmpty) {
                          return;
                        }

                        await taskController.shareWithEmail(
                          widget.task.id ?? "",
                          email,
                        );
                      },
                      child: const Icon(Icons.share),
                    ),
                  if ((widget.task.ownerEmail ?? "") == (user?.email ?? ""))
                    const Spacer(),

                  FloatingActionButton(
                    heroTag: UniqueKey(),
                    onPressed: () async {
                      if ((widget.task.id ?? "").isEmpty) {
                        return;
                      }

                      await taskController
                          .update(widget.task.id ?? "", <String, dynamic>{
                            "title": titleController.text,
                            "description": descriptionController.text,
                          });

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Icon(Icons.check),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
