import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final String title;
  final double? borderRadius;
  final double? horizontalContentPadding;
  final double? verticalContentPadding;
  final int? maxLines;
  final bool showText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isDate;
  final bool isPhone;
  final bool isPeriodOftime;
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final bool enabled;
  const CustomTextField(
      {this.prefixIcon,
      this.horizontalContentPadding,
      this.verticalContentPadding,
      this.maxLines = 1,
      this.borderRadius,
      required this.title,
      this.sufixIcon,
      super.key,
      this.controller,
      this.showText = false,
      this.keyboardType,
      this.isDate = false,
      this.isPeriodOftime = false,
      this.enabled = true,
      this.isPhone = false,
      this.onSubmit,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmit,
      keyboardType: keyboardType,
      obscureText: showText,
      onChanged: onChange,
      controller: controller,
      maxLines: maxLines,
      cursorColor: Colors.black54,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: sufixIcon != null
            ? Container(
                width: 22,
                height: 14,
                alignment: Alignment.center,
                child: sufixIcon)
            : null,
        prefixIcon: prefixIcon != null
            ? Container(
                width: 22,
                height: 14,
                alignment: Alignment.center,
                child: prefixIcon)
            : null,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalContentPadding ?? 16,
            vertical: verticalContentPadding ?? 16),
        hintText: title,
        enabled: enabled,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: AppColors.grey),
        //   borderRadius: BorderRadius.circular(borderRadius ?? 8),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: AppColors.primary),
        //   borderRadius: BorderRadius.circular(borderRadius ?? 8),
        // ),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(borderRadius ?? 8),
        //     borderSide: BorderSide(color: AppColors.lightGrey)),
      ),
    );
  }
}
