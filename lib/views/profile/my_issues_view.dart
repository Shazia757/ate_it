import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/issue_controller.dart';
import '../../model/issue_model.dart';

class MyIssuesView extends StatelessWidget {
  const MyIssuesView({super.key});

  @override
  Widget build(BuildContext context) {
    final IssueController controller = Get.put(IssueController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reported Issues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchIssues(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.issues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.issues.isEmpty) {
          return const Center(child: Text('No issues reported yet.'));
        }

        return ListView.builder(
          itemCount: controller.issues.length,
          itemBuilder: (context, index) {
            final issue = controller.issues[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(issue.title.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(issue.description.toString()),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${issue.status}',
                      style: TextStyle(
                          color: issue.status == 'Resolved'
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          _showEditDialog(context, controller, issue),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _showDeleteConfirmation(context, controller, issue),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showEditDialog(
      BuildContext context, IssueController controller, IssueStatus issue) {
    final titleEdit = TextEditingController(text: issue.title);
    final descEdit = TextEditingController(text: issue.description);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleEdit,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: descEdit,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.updateIssue(issue.id!, titleEdit.text, descEdit.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, IssueController controller, IssueStatus issue) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Issue'),
        content:
            const Text('Are you sure you want to delete this issue report?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.deleteIssue(issue.id!);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
