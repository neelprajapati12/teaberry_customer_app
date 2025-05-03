import 'package:flutter/material.dart';
// import 'package:towing_app/constants/app_colors.dart';
// import 'package:local/Constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? errortext;
  final int? maxlength;
  final bool isPassword;
  final String? Function(String?)? validator;

  CustomTextFormField({
    Key? key,
    required this.controller,
    this.errortext,
    this.maxlength,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxlength,
      obscureText: isPassword,
      buildCounter:
          (_, {required currentLength, required isFocused, maxLength}) => null,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black38),
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        // Apply the same border style to all states
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return errortext;
            }
            return null;
          },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final Color hintColor;
  final Color labelColor;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final VoidCallback? onFocusChanged;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Icon? suffixIcon;
  final TextInputType? keyboardtype;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.hintColor = Colors.grey,
    this.labelColor = Colors.grey,
    this.maxLines,
    this.maxLength,
    this.focusNode,
    this.onFocusChanged,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.keyboardtype,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SizedBox(
      // height: 0.09 * h, // Increase height
      width: double.infinity,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: Colors.black,
        keyboardType: keyboardtype,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w600,
            fontFamily: "popR",
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38),
          fillColor: Colors.grey[100],
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.grey),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.6)),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          suffixIcon:
              suffixIcon != null
                  ? GestureDetector(onTap: onTap, child: suffixIcon)
                  : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ), // Add content padding
        ),
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500, // Adjust font size as needed
        ),
      ),
    );
  }
}
