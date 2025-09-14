import 'package:flutter/material.dart';

enum SocialLoginType {
  google,
  facebook,
  apple,
}

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getIcon(),
        const SizedBox(width: 12),
        Text(
          _getButtonText(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _getIcon() {
    switch (type) {
      case SocialLoginType.google:
        return const Icon(
          Icons.g_mobiledata, // Placeholder - would use actual Google logo in real app
          size: 24,
          color: Colors.red,
        );
      case SocialLoginType.facebook:
        return const Icon(
          Icons.facebook, 
          size: 24,
          color: Color(0xFF1877F2), // Facebook blue
        );
      case SocialLoginType.apple:
        return const Icon(
          Icons.apple,
          size: 24,
          color: Colors.black,
        );
    }
  }

  String _getButtonText() {
    switch (type) {
      case SocialLoginType.google:
        return 'Continue with Google';
      case SocialLoginType.facebook:
        return 'Continue with Facebook';
      case SocialLoginType.apple:
        return 'Continue with Apple';
    }
  }
}