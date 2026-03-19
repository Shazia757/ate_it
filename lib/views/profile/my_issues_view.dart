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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.report_problem,
                    size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 10),
                const Text(
                  "No issues reported yet",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.issues.length,
          itemBuilder: (context, index) {
            final issue = controller.issues[index];

            final isResolved = issue.status == 'Resolved';

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔴 TITLE + STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          issue.title ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isResolved
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          issue.status ?? '',
                          style: TextStyle(
                            color: isResolved ? Colors.green : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 📄 DESCRIPTION
                  Text(
                    issue.description ?? '',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 14),

                  Divider(color: Colors.grey.shade200),

                  const SizedBox(height: 8),

                  // 🔘 ACTIONS (only if OPEN)
                  if (issue.status == 'OPEN')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              _showEditDialog(context, controller, issue),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text("Edit"),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => _showDeleteConfirmation(
                              context, controller, issue),
                          icon: const Icon(Icons.delete,
                              size: 18, color: Colors.red),
                          label: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                ],
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

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔴 HANDLE BAR
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                "Edit Issue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // ✏️ TITLE FIELD
              TextField(
                controller: titleEdit,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 📄 DESCRIPTION FIELD
              TextField(
                controller: descEdit,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔘 ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.updateIssue(
                          issue.id!,
                          titleEdit.text,
                          descEdit.text,
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
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
