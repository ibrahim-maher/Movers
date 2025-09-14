import 'package:flutter/material.dart';
import 'text_input_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final Color? fillColor;
  final bool filled;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final bool showPasswordStrength;
  final bool showToggleButton;

  const PasswordField({
    super.key,
    this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.helperText,
    this.errorText,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.prefixIcon = const Icon(Icons.lock_outline),
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.fillColor,
    this.filled = true,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.showPasswordStrength = false,
    this.showToggleButton = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputField(
          controller: widget.controller,
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          onSubmitted: widget.onSubmitted,
          validator: widget.validator,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.showToggleButton ? _buildToggleButton() : null,
          contentPadding: widget.contentPadding,
          border: widget.border,
          enabledBorder: widget.enabledBorder,
          focusedBorder: widget.focusedBorder,
          errorBorder: widget.errorBorder,
          focusedErrorBorder: widget.focusedErrorBorder,
          fillColor: widget.fillColor,
          filled: widget.filled,
          style: widget.style,
          labelStyle: widget.labelStyle,
          hintStyle: widget.hintStyle,
          errorStyle: widget.errorStyle,
        ),
        if (widget.showPasswordStrength && _password.isNotEmpty)
          _buildPasswordStrengthIndicator(),
      ],
    );
  }

  Widget _buildToggleButton() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = _calculatePasswordStrength(_password);
    final theme = Theme.of(context);

    Color strengthColor;
    String strengthText;

    if (strength < 0.3) {
      strengthColor = Colors.red;
      strengthText = 'Weak';
    } else if (strength < 0.7) {
      strengthColor = Colors.orange;
      strengthText = 'Medium';
    } else {
      strengthColor = Colors.green;
      strengthText = 'Strong';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: strength,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 4),
          Text(
            'Password strength: $strengthText',
            style: TextStyle(
              fontSize: 12,
              color: strengthColor,
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    
    double strength = 0.0;
    
    // Length check
    if (password.length >= 8) strength += 0.2;
    if (password.length >= 12) strength += 0.2;
    
    // Character variety checks
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.1;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.3;
    
    return strength.clamp(0.0, 1.0);
  }
}