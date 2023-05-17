import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final TextEditingController? controller;
  final String Function(String?)? validator;
  final String? hintText;
  final bool? obscureText;
  final Widget? suffixIcon;
  const TextFieldContainer(
      {Key? key,
      this.controller,
      this.validator,
      this.hintText,
      this.obscureText,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        suffixIconColor:
            (obscureText ?? true) ? Colors.grey : const Color(0xFF192396),
        border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color(0xFF8C91CB), style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF909090),
          fontWeight: FontWeight.w400,
          fontFamily: 'SF-Pro',
          fontSize: 17,
        ),
      ),
    );
  }
}
