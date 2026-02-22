import 'dart:developer';
import 'package:ate_it/services/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/issue_model.dart';

class IssueController extends GetxController {
  var issues = <IssueStatus>[].obs;
  var isLoading = false.obs;
  var isButtonLoading = false.obs;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchIssues();
  }

  Future<void> fetchIssues() async {
    isLoading.value = true;
    try {
      final response = await ApiService().getIssues().then(
        (value) {
          issues.assignAll(value?.data?.results ?? []);
        },
      );
      if (response != null) {
        issues.assignAll(response.issues);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void submitIssue() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
    }

    isLoading.value = true;
    try {
      await ApiService().reportIssue({
        'title': titleController.text,
        'description': descriptionController.text,
      }).then(
        (value) {
          if (value?.status == true) {
            Get.back();
            Get.back();
            Get.snackbar('Success', 'Issue Reported');
          } else {
            Get.snackbar('Error', 'Failed to report');
          }
          log(value!.status.toString());
          isLoading.value = false;
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateIssue(int id, String title, String description) async {
    isLoading.value = true;
    try {
      final success = await ApiService().updateIssue(id, {
        'title': title,
        'description': description,
      });
      if (success) {
        Get.snackbar('Success', 'Issue updated successfully');
        fetchIssues();
      } else {
        Get.snackbar('Error', 'Failed to update issue');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteIssue(int id) async {
    isLoading.value = true;
    try {
      final success = await ApiService().deleteIssue(id);
      if (success) {
        Get.snackbar('Success', 'Issue deleted successfully');
        fetchIssues();
      } else {
        Get.snackbar('Error', 'Failed to delete issue');
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
