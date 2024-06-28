import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLines;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
    this.suffixIcon,
    this.onTap,
    this.prefixIcon,
    this.validator,
    this.focusNode,
    this.errorMsg,
    this.onChanged,
    required this.enabled,
    this.maxLines,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onTap: onTap,
      maxLines: maxLines,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth,
                ),
              )
            : InputBorder.none,
        focusedBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: borderColor ?? Theme.of(context).colorScheme.secondary,
                  width: borderWidth,
                ),
              )
            : InputBorder.none,
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        errorText: errorMsg,
      ),
    );
  }
}
