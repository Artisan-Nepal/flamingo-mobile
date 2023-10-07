import 'package:flutter/material.dart';
import 'package:flamingo/widget/text-field/text_field.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  const PasswordTextFieldWidget({
    super.key,
    this.obscureTextInitially = true,
    this.focusNode,
    this.nextNode,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.label,
    this.onChanged,
    this.validator,
    this.autoFocus = false,
    this.autovalidateMode,
    this.maxLength,
    this.onFieldSubmitted,
    this.onSaved,
    this.onPrefixPressed,
  });

  final bool obscureTextInitially;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool autoFocus;
  final AutovalidateMode? autovalidateMode;
  final int? maxLength;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function()? onPrefixPressed;

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  late bool _obscureText;

  toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _obscureText = widget.obscureTextInitially;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      focusNode: widget.focusNode,
      nextNode: widget.nextNode,
      controller: widget.controller,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      onPrefixPressed: widget.onPrefixPressed,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      label: widget.label,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autoFocus: widget.autoFocus,
      autovalidateMode: widget.autovalidateMode,
      maxLength: widget.maxLength,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      obscureText: _obscureText,
      maxLines: 1,
      suffixIcon: _obscureText ? Icons.visibility_off : Icons.visibility,
      onSuffixPressed: toggleObscureText,
    );
  }
}
