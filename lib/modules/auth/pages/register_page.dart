import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../routes/app_routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('sign_up'.tr),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'create_account'.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  // Full Name Field
                  Obx(
                        () => TextFormField(
                      controller: controller.fullNameController,
                      decoration: InputDecoration(
                        labelText: 'full_name'.tr,
                        prefixIcon: const Icon(Icons.person),
                        errorText: controller.fullNameError.value.isEmpty
                            ? null
                            : controller.fullNameError.value.tr,
                      ),
                      validator: controller.validateFullName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Email Field
                  Obx(
                        () => TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: 'email'.tr,
                        prefixIcon: const Icon(Icons.email),
                        errorText: controller.emailError.value.isEmpty
                            ? null
                            : controller.emailError.value.tr,
                      ),
                      validator: controller.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Phone Field
                  Obx(
                        () => TextFormField(
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                        labelText: 'phone_number'.tr,
                        prefixIcon: const Icon(Icons.phone),
                        errorText: controller.phoneError.value.isEmpty
                            ? null
                            : controller.phoneError.value.tr,
                      ),
                      validator: controller.validatePhone,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  Obx(
                        () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'password'.tr,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        errorText: controller.passwordError.value.isEmpty
                            ? null
                            : controller.passwordError.value.tr,
                      ),
                      validator: controller.validatePassword,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password Field
                  Obx(
                        () => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'confirm_password'.tr,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                        errorText: controller.confirmPasswordError.value.isEmpty
                            ? null
                            : controller.confirmPasswordError.value.tr,
                      ),
                      validator: controller.validateConfirmPassword,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Strength Indicator
                  Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'password_strength'.tr}: ${controller.getPasswordStrengthText().tr}',
                          style: TextStyle(
                            color: controller.getPasswordStrengthColor(),
                          ),
                        ),
                        LinearProgressIndicator(
                          value: controller.getPasswordStrength(),
                          color: controller.getPasswordStrengthColor(),
                          backgroundColor: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Terms and Conditions Checkbox
                  Obx(
                        () => Row(
                      children: [
                        Checkbox(
                          value: controller.acceptTerms.value,
                          onChanged: controller.toggleAcceptTerms,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.showTermsAndConditions,
                            child: Text(
                              'accept_terms'.tr,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Register Button
                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.registerWithEmailAndPassword,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : Text('sign_up'.tr),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.registerWithGoogle,
                      icon: const Icon(Icons.g_mobiledata),
                      label: Text('sign_up_with_google'.tr),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Login Link
                  TextButton(
                    onPressed: controller.goToLogin,
                    child: Text('already_have_account'.tr),
                  ),
                  // Privacy Policy Link
                  TextButton(
                    onPressed: controller.showPrivacyPolicy,
                    child: Text('privacy_policy'.tr),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}