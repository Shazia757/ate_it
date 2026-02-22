import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'issue_report_view.dart';
import 'my_issues_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
        actions: [
          Obx(() => IconButton(
                icon:
                    Icon(controller.isEditing.value ? Icons.save : Icons.edit),
                onPressed: controller.toggleEdit,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final isEditing = controller.isEditing.value;
          return Column(
            children: [
              _buildField(
                  'First Name', controller.firstNameController, isEditing),
              _buildField(
                  'Last Name', controller.lastNameController, isEditing),
              _buildField('Username', controller.usernameController, isEditing),
              _buildField('Phone', controller.phoneController, isEditing,
                  isPhone: true),
              _buildField('Email', controller.emailController, isEditing),
              // Row(
              //   children: [
              //     Expanded(
              //         child: _buildField(
              //             'State', controller.stateController, isEditing)),
              //     const SizedBox(width: 16),
              //     Expanded(
              //         child: _buildField('District',
              //             controller.districtController, isEditing)),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //         child: _buildField(
              //             'City', controller.cityController, isEditing)),
              //     const SizedBox(width: 16),
              //     Expanded(
              //         child: _buildField(
              //             'Pincode', controller.pincodeController, isEditing)),
              //   ],
              // ),
              _ActionButton(
                  icon: Icons.report,
                  label: 'Report an Issue',
                  onTap: () => Get.to(() => const IssueReportView()),
                  isFullWidth: true),

              const SizedBox(height: 10),
              _ActionButton(
                  icon: Icons.report_problem,
                  label: 'Reported Issues',
                  onTap: () => Get.to(() => const MyIssuesView()),
                  isFullWidth: true),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100)),
                onPressed: () => controller.logout(),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Logout'),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, bool isEditing,
      {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: !isEditing,
          fillColor: isEditing ? Colors.white : Colors.grey.shade100,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isFullWidth;

  const _ActionButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isFullWidth = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 125),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
