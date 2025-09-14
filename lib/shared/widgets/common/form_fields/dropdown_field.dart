import 'package:flutter/material.dart';

class DropdownField<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final bool isExpanded;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
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
  final double? menuMaxHeight;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool autofocus;
  final FocusNode? focusNode;

  const DropdownField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.isExpanded = true,
    this.prefixIcon,
    this.suffixIcon,
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
    this.menuMaxHeight,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: theme.colorScheme.outline),
    );

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: isExpanded,
      icon: icon ?? const Icon(Icons.arrow_drop_down),
      iconDisabledColor: iconDisabledColor,
      iconEnabledColor: iconEnabledColor,
      iconSize: iconSize,
      isDense: isDense,
      menuMaxHeight: menuMaxHeight,
      autofocus: autofocus,
      focusNode: focusNode,
      style: style ?? theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: border ?? defaultBorder,
        enabledBorder: enabledBorder ?? defaultBorder,
        focusedBorder: focusedBorder ?? defaultBorder.copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2.0,
          ),
        ),
        errorBorder: errorBorder ?? defaultBorder.copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
        focusedErrorBorder: focusedErrorBorder ?? defaultBorder.copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2.0,
          ),
        ),
        filled: filled,
        fillColor: fillColor ?? theme.colorScheme.surface,
        labelStyle: labelStyle,
        hintStyle: hintStyle ?? TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        errorStyle: errorStyle ?? TextStyle(
          color: theme.colorScheme.error,
          fontSize: 12.0,
        ),
        enabled: enabled,
      ),
    );
  }

  /// Helper method to create a list of DropdownMenuItem from a list of values
  static List<DropdownMenuItem<T>> buildItems<T>(
    List<T> items, {
    required String Function(T) labelBuilder,
    Widget Function(T)? widgetBuilder,
  }) {
    return items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: widgetBuilder != null
            ? widgetBuilder(item)
            : Text(labelBuilder(item)),
      );
    }).toList();
  }
}