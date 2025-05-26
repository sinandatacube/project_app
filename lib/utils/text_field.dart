import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool? obscureText;
  final bool isNumber;
  final bool? isReadOnly;
  final bool? autofocus;
  final String? hintText;
  final Function()? onTap;
  final Function(String)? onChanged; // ✅ Add this

  const CustomTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    required this.isNumber,
    this.obscureText = false,
    this.hintText,
    this.isReadOnly,
    this.onTap,
    this.autofocus,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        readOnly: isReadOnly ?? false,
        onTap: onTap,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "*required";
          } else {
            return null;
          }
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        obscureText: obscureText ?? false,
        autofocus: autofocus ?? false,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
          prefixIcon:
              prefixIcon == null ? null : Icon(prefixIcon, color: Colors.grey),
          contentPadding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          errorStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
