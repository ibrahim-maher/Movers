import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? textColor;
  final double? fontSize;
  final FontWeight fontWeight;
  final bool underline;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.textColor,
    this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txtColor = textColor ?? theme.colorScheme.primary;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: txtColor,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),
      child: _buildButtonContent(txtColor, context),
    );
  }

  Widget _buildButtonContent(Color txtColor, BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(txtColor),
        ),
      );
    }

    final textStyle = TextStyle(
      color: txtColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: underline ? TextDecoration.underline : null,
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: fontSize != null ? fontSize! + 2 : 18),
          const SizedBox(width: 4),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }
}