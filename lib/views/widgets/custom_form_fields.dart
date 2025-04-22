import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool isEmail;
  final bool isPhone;
  final bool isName;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const CustomFormField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isEmail = false,
    this.isPhone = false,
    this.isName = false,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      obscureText: isPassword,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhone
              ? TextInputType.phone
              : TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        prefixIcon: _getPrefixIcon(),
        suffixIcon: isPassword
            ? IconButton(
                icon: const Icon(Icons.visibility_off),
                onPressed: () {
                  // Toggle password visibility logic would go here
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Icon _getPrefixIcon() {
    if (isPassword) {
      return const Icon(Icons.lock, color: Colors.grey);
    } else if (isEmail) {
      return const Icon(Icons.email, color: Colors.grey);
    } else if (isPhone) {
      return const Icon(Icons.phone, color: Colors.grey);
    } else if (isName) {
      return const Icon(Icons.person, color: Colors.grey);
    }
    return const Icon(Icons.edit, color: Colors.grey);
  }
}