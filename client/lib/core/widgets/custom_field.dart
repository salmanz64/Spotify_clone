import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool readOnly;
  final bool isObscure;
  final VoidCallback? onTap;
  const CustomField({
    super.key,
    required this.hintText,
    this.onTap,
    required this.controller,
    this.readOnly = false,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      obscureText: isObscure,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText missing";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
