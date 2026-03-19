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
      body: Obx(() {
        final isEditing = controller.isEditing.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔴 PROFILE HEADER
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.teal.shade100,
                    child:
                        const Icon(Icons.person, size: 40, color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${controller.firstNameController.text} ${controller.lastNameController.text}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    controller.emailController.text,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔴 PROFILE INFO CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildField("First Name", controller.firstNameController,
                        isEditing),
                    _buildField(
                        "Last Name", controller.lastNameController, isEditing),
                    _buildField(
                        "Username", controller.usernameController, isEditing),
                    _buildField("Phone", controller.phoneController, isEditing,
                        isPhone: true),
                    _buildField("Email", controller.emailController, isEditing),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔴 LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  label: controller.isButtonLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            const Text("Logout"),
                          ],
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, bool isEditing,
      {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEditing ? Colors.white : Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}
