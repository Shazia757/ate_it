import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

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
                icon: (controller.isEditing.value)
                    ? (controller.isLoading.value)
                        ? (CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : (Icon(Icons.save))
                    : Icon(Icons.edit),
                onPressed: () => controller.toggleEdit(),
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
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100)),
                onPressed: () => controller.logout(),
                child: controller.isButtonLoading.value
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
