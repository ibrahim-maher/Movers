import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'text_input_field.dart';

class DatePickerField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool readOnly;
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
  final String? dateFormat;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool autofocus;

  const DatePickerField({
    super.key,
    this.labelText = 'Date',
    this.hintText = 'Select a date',
    this.helperText,
    this.errorText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon = const Icon(Icons.calendar_today),
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
    this.dateFormat = 'MMM dd, yyyy',
    this.focusNode,
    this.controller,
    this.autofocus = false,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _dateFormat = DateFormat(widget.dateFormat);
    _selectedDate = widget.initialDate;
    
    if (_selectedDate != null) {
      _controller.text = _dateFormat.format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      controller: _controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      readOnly: true,
      enabled: widget.enabled,
      validator: widget.validator,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.enabled
          ? IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: _showDatePicker,
            )
          : null,
      onTap: widget.enabled ? _showDatePicker : null,
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
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
    );
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? widget.initialDate ?? now;
    final firstDate = widget.firstDate ?? DateTime(now.year - 100, now.month, now.day);
    final lastDate = widget.lastDate ?? DateTime(now.year + 100, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _dateFormat.format(picked);
      });

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }
}