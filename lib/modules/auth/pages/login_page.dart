import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      size: 50,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    'sign_in'.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 48),
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
                  // Remember Me Checkbox
                  Obx(
                        () => Row(
                      children: [
                        Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: controller.toggleRememberMe,
                        ),
                        Text('remember_me'.tr),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Login Button
                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.signInWithEmailAndPassword,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : Text('sign_in'.tr),
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
                          : controller.signInWithGoogle,
                      icon: const Icon(Icons.g_mobiledata),
                      label: Text('sign_in_with_google'.tr),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Forgot Password Link
                  TextButton(
                    onPressed: controller.goToForgotPassword,
                    child: Text('forgot_password'.tr),
                  ),
                  // Register Link
                  TextButton(
                    onPressed: controller.goToRegister,
                    child: Text('create_account'.tr),
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