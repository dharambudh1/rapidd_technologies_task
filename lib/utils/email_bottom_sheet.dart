import "package:flutter/material.dart";

class EmailBottomSheet extends StatefulWidget {
  const EmailBottomSheet({super.key});

  @override
  State<EmailBottomSheet> createState() => _EmailBottomSheetState();
}

class _EmailBottomSheetState extends State<EmailBottomSheet> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 56.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, emailController.text.trim());
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
