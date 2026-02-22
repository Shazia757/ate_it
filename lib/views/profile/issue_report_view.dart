import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/issue_controller.dart';

class IssueReportView extends StatelessWidget {
  const IssueReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final IssueController controller = Get.put(IssueController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report an Issue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                hintText: 'Briefly describe the issue',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Provide more details about what happened...',
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async => controller.isLoading.value
                        ? CircularProgressIndicator()
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                title: Text('Report issue'),
                                content: Text(
                                    'Are you sure you want to report the issue?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text("Cancel")),
                                  TextButton(
                                    onPressed: () => controller.submitIssue(),
                                    child: Obx(() =>
                                        (controller.isLoading.value)
                                            ? CircularProgressIndicator()
                                            : Text("Confirm")),
                                  ),
                                ],
                              );
                            },
                          ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: (controller.isButtonLoading.value)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit Report'),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
